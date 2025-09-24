from django.shortcuts import render
from django.http import Http404
from lxml import etree

from ..services.alvin_api import AlvinAPI
from ..extractors import person, place, organisation, work, record as record_ex
from ..xmlutils.nodes import elements

EXTRACTORS = {
    "alvin-person": person.extract,
    "alvin-place": place.extract,
    "alvin-organisation": organisation.extract,
    "alvin-work": work.extract,
    "alvin-record": record_ex.extract,
}

def extract_metadata(root: etree._Element, record_type: str) -> dict:
    # Gemensamt
    common = {
        "id": root.findtext(".//recordInfo/id"),
        "created": root.findtext(".//tsCreated"),
        "last_updated": elements(root, "//tsUpdated")[-1].findtext(".") if root.xpath("//tsUpdated") else None,
        "source_xml": root.findtext("./actionLinks/read/url"),
        "record_type": record_type,
    }
    extractor = EXTRACTORS.get(record_type)
    if not extractor:
        raise Http404("Invalid record type")
    data = extractor(root)
    return {**common, **data}

def alvin_viewer(request, record_type: str, record_id: str):
    api = AlvinAPI()
    try:
        root = api.get_record_xml(record_type, record_id)
    except Exception as e:
        raise Http404(str(e))

    metadata = extract_metadata(root, record_type)
    context = {"metadata": metadata, "xml": etree.tostring(root)}
    return render(request, "alvin_viewer/alvin_viewer.html", context)