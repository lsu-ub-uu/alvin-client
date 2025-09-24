from dataclasses import dataclass
import requests
from lxml import etree
from django.conf import settings

XML_HEADERS = {
    "Content-Type": "application/vnd.cora.record+xml",
    "Accept": "application/vnd.cora.record+xml",
}

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

    def fetch_xml(self, url: str) -> etree._Element:
        resp = self.session.get(url, timeout=(3, 15))
        resp.raise_for_status()
        try:
            return etree.fromstring(resp.content)
        except etree.XMLSyntaxError as e:
            raise ValueError(f"Invalid XML from {url}: {e}") from e

    def get_record_xml(self, record_type: str, record_id: str) -> etree._Element:
        path_tpl = self.endpoints.paths.get(record_type)
        if not path_tpl:
            raise ValueError(f"Invalid record type: {record_type}")
        url = f"{self.endpoints.base}/{path_tpl.format(id=record_id)}"
        return self.fetch_xml(url)

    def fetch_file_xml(self, url: str) -> etree._Element:
        return self.fetch_xml(url)