import logging
from typing import Optional
import requests
from django.core.cache import cache
from lxml import etree
import threading
from urllib3.util.retry import Retry
from requests.adapters import HTTPAdapter
from django.conf import settings

MAX_WORKERS = 8
REQUEST_TIMEOUT = 15
CACHE_DICT_KEY = "collection_item_cache_dict"
_DICT_LOCK = threading.RLock()

def _session(max_workers: int = MAX_WORKERS) -> requests.Session:
    s = requests.Session()
    retry = Retry(total=5, connect=3, read=3, backoff_factor=0.5, status_forcelist=(429, 500, 502, 503, 504))
    adapter = HTTPAdapter(max_retries=retry, pool_connections=max_workers, pool_maxsize=max_workers)
    s.mount("http://", adapter)
    s.mount("https://", adapter)
    return s

logger = logging.getLogger(__name__)
session = _session()

COLLECTIONS = [
    #common
    "languageCodeCollection",

    #alvin-record
    "identifierTypeCollection",
    "classificationSchemeCollection",
    "variantTitleTypeCollection",
    "dateTypeCollection",
    "noteTypeCollection",
    "noteTypeInternalCollection",
    "physicalDescriptionNoteTypeCollection",
    "subjectHeadingSchemaCollection",
    "relatedToTypeCollection",

    #alvin-person
    "variantPersonNameTypeCollection",
    "noteTypeAuthorityCollection",

    #alvin-organisation
    "variantOrganisationNameTypeCollection",
    "relatedOrganisationTypeCollection"
]

def _deco_get_xml_bytes(collection) -> bytes:
    headers = {"Accept": "application/vnd.cora.record-decorated+xml"}
    resp = session.get(
        f"{settings.API_HOST}/rest/record/metadata/{collection}",
        headers=headers,
        timeout=REQUEST_TIMEOUT
        )
    resp.raise_for_status()
    return resp.content

def _deco_process_collection(collection) -> dict:
    xml_bytes = _deco_get_xml_bytes(collection)
    parser = etree.XMLParser(remove_blank_text=True, recover=True, huge_tree=True)
    root = etree.fromstring(xml_bytes, parser=parser)

    collection_items = root.xpath("//metadata[@type='collectionItem']")

    result: Dict[str, Dict[str, str]] = {}
    for item in collection_items:
        name = item.findtext("nameInData")
        texts = {tp.get("lang"): tp.findtext("text") for tp in item.xpath("textId/linkedRecord/text/textPart")}
        result.update({name: texts})

    logger.info(f"Found {len(collection_items)} collection items in {collection}, collected {len(result)} items.")
    return result

def _deco_cache_collections(collections) -> None:
    result: Dict[str, Dict[str, str]] = {}
    for collection in collections:
        result.update(_deco_process_collection(collection))
    cache.set(CACHE_DICT_KEY, result)
    logger.info("Processed XML and stored dictionary in cache.")

def _reload_items() -> None:
    d = cache.get(CACHE_DICT_KEY)
    if d is not None:
        logger.info("Dicionary already cached successfully.")
        return d
    try:
        d = _deco_cache_collections(COLLECTIONS)
        logger.info("Collections processed and cached successfully.")
    except Exception:
        logger.exception("Could not process XML from cache.")
        return {}

def get_item_dict() -> Optional[dict]:
    with _DICT_LOCK:
        d = cache.get(CACHE_DICT_KEY)
        if d is None:
            _reload_items()
            d = cache.get(CACHE_DICT_KEY)
        return d or None