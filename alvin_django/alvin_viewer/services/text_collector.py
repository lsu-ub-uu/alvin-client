import logging
from typing import Optional, Any
import requests
from django.core.cache import cache
from lxml import etree

logger = logging.getLogger(__name__)

session = requests.Session()

CACHE_DICT_KEY = "collection_item_cache_dict"
ITEM_DICT: Optional[etree._ElementTree] = None

def _get_xml_bytes() -> bytes:
    headers = {"Accept": "application/vnd.cora.recordList+xml"}
    s = session.get("https://cora.alvin-portal.org/rest/record/metadata/", headers=headers, timeout=15)
    s.raise_for_status()
    logger.info(f"Fetched XML: {len(s.content)} bytes")
    return s.content

def _process_xml() -> dict:
    if cache.get(CACHE_DICT_KEY) is not None:
        logger.info("XML already in cache, skipping processing.")
        return cache.get(CACHE_DICT_KEY) 

    xml_bytes = _get_xml_bytes()
    root = etree.fromstring(xml_bytes)
    collection_items = root.xpath("//metadata[@type='collectionItem']")
    logger.info(f"Found {len(collection_items)} collection items.")

    ci = {}

    for item in collection_items:
        name = item.findtext("nameInData")
        text_url = item.findtext("textId/actionLinks/read/url")
        s = session.get(text_url, timeout=15)
        s.raise_for_status()

        text_data = s.content
        lang_data = etree.fromstring(text_data)

        text_dict = {}
        for data in lang_data.xpath(".//textPart"):
            text_dict.update({data.get("lang"): data.findtext("text")})
        
        ci.update({name: text_dict})
    
    cache.set(CACHE_DICT_KEY, ci, timeout=60 * 60 * 6)
    logger.info("XML stored in cache.")
    logger.info("Processed XML and stored dictionary in cache.")

def _reload_items() -> None:
    global ITEM_DICT
    try:
        ITEM_DICT = _process_xml()
        logger.info("Processed XML tree successfully.")
    except Exception:
        logger.exception("Could not process XML from cache.")

def get_item_dict() -> Optional[etree._ElementTree]:
    global ITEM_DICT
    if ITEM_DICT is None:
        _reload_items()
    return ITEM_DICT

def xpath_value(path: str) -> list[Any]:
    tree = get_xml_tree()
    if tree is None:
        return []
    return tree.xpath(path)