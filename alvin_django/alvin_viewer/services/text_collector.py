import logging
from typing import Optional, Any
import requests
from django.core.cache import cache
from lxml import etree

logger = logging.getLogger(__name__)

CACHE_XML_KEY = "collection_item_cache"
ITEM_TREE: Optional[etree._ElementTree] = None

def _get_content_bytes() -> bytes:
    headers = {"Accept": "application/vnd.cora.recordList+xml"}
    r = requests.get("https://cora.alvin-portal.org/rest/record/text/", headers=headers, timeout=15)
    r.raise_for_status()
    logger.info(f"Fetched XML: {len(r.content)} bytes")
    return r.content

def collect_texts() -> None:
    if cache.get(CACHE_XML_KEY) is None:
        xml_bytes = _get_content_bytes()
        cache.set(CACHE_XML_KEY, xml_bytes, timeout=60 * 60 * 6)
        logger.info("XML stored in cache.")

def _parse_xml(xml_bytes: bytes) -> etree._ElementTree:
    root = etree.fromstring(xml_bytes)
    return etree.ElementTree(root)

def _reload_tree() -> None:
    global ITEM_TREE
    xml_bytes = cache.get(CACHE_XML_KEY)
    if not xml_bytes:
        logger.warning("No XML found in cache.")
        return
    try:
        ITEM_TREE = _parse_xml(xml_bytes)
        logger.info("Parsed XML tree successfully.")
    except Exception:
        logger.exception("Could not parse XML from cache.")

def get_xml_tree() -> Optional[etree._ElementTree]:
    global ITEM_TREE
    if ITEM_TREE is None:
        _reload_tree()
    return ITEM_TREE

def xpath_value(path: str) -> list[Any]:
    tree = get_xml_tree()
    if tree is None:
        return []
    return tree.xpath(path)