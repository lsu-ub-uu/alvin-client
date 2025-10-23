from dataclasses import dataclass
import hashlib
import requests
from lxml import etree
from django.conf import settings
from django.core.cache import cache
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

XML_HEADERS = {
    "Content-Type": "application/vnd.cora.record+xml",
    "Accept": "application/vnd.cora.record-decorated+xml",
    "Accept-Encoding": "gzip, deflate",
}

SAFE_XML_PARSER = etree.XMLParser(resolve_entities=False, no_network=True, huge_tree=False)


@dataclass(frozen=True)
class AlvinEndpoints:
    base: str
    paths: dict
    
    @staticmethod
    def default():
        return AlvinEndpoints(
            base=f"{settings.API_HOST}/rest/record",
            paths={
                "alvin-place": "alvin-place/{id}",
                "alvin-person": "alvin-person/{id}",
                "alvin-organisation": "alvin-organisation/{id}",
                "alvin-work": "alvin-work/{id}",
                "alvin-record": "alvin-record/{id}",
            },
        )

class AlvinAPI:
    def __init__(self, endpoints: AlvinEndpoints | None = None):
        self.endpoints = endpoints or AlvinEndpoints.default()
        self.session = requests.Session()
        self.session.headers.update(XML_HEADERS)

        retry = Retry(
            total=3,
            backoff_factor=0.5,
            status_forcelist=(429, 500, 502, 503, 504),
            allowed_methods=("GET",),
            raise_on_status=False,
        )
        adapter = HTTPAdapter(max_retries=retry, pool_connections=10, pool_maxsize=10)
        self.session.mount("http://", adapter)
        self.session.mount("https://", adapter)

    def _parse_xml(self, content: bytes) -> etree._Element:
        try:
            return etree.fromstring(content, parser=SAFE_XML_PARSER)
        except etree.XMLSyntaxError as e:
            raise ValueError(f"Invalid XML: {e}") from e

    def fetch_xml(self, url: str, *, cache_key: str | None = None, ttl: int = 60) -> etree._Element:
        if cache_key:
            cached = cache.get(cache_key)
            if cached is not None:
                return self._parse_xml(cached)
        resp = self.session.get(url, timeout=(3, 15), allow_redirects=False)
        resp.raise_for_status()
        content = resp.content
        if cache_key:
            cache.set(cache_key, content, ttl)
        return self._parse_xml(content)

    def get_record_xml(self, record_type: str, record_id: str) -> etree._Element:
        path_tpl = self.endpoints.paths.get(record_type)
        if not path_tpl:
            raise ValueError(f"Invalid record type: {record_type}")
        url = f"{self.endpoints.base}/{path_tpl.format(id=record_id)}"
        if not url.startswith(self.endpoints.base):
            raise ValueError("Blocked URL (potential SSRF)")
        return self.fetch_xml(url, cache_key=f"alvin:{record_type}:{record_id}", ttl=120)

    def fetch_file_xml(self, url: str) -> etree._Element:
        base = f"{settings.API_HOST}/"
        if not url.startswith(base):
            raise ValueError("Blocked external URL (potential SSRF)")
        return self.fetch_xml(url, cache_key=f"alvin:file:{hash(url)}", ttl=300)