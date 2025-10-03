from django.shortcuts import render
from django.http import Http404
from lxml import etree

from ..services.alvin_api import AlvinAPI
from ..extractors import person, place, organisation, work, record as record
from ..xmlutils.nodes import elements

# Select extractor based on record_type
EXTRACTORS = {
    "alvin-person": person.extract,
    "alvin-place": place.extract,
    "alvin-organisation": organisation.extract,
    "alvin-work": work.extract,
    "alvin-record": record.extract,
}

def extract_metadata(root: etree._Element, record_type: str) -> dict:
    # Common metadata
    common = {
        "id": root.findtext(f"./data/{record_type.strip("alvin-")}/recordInfo/id"),
        "created": root.findtext(f"./data/{record_type.strip("alvin-")}/recordInfo/tsCreated"),
        "last_updated": 
            elements(root, f"./data/{record_type.strip("alvin-")}/recordInfo//tsUpdated")[-1].findtext(".") if
            elements(root, f"./data/{record_type.strip("alvin-")}/recordInfo//tsUpdated") 
            else None,
        "source_xml": root.findtext("./actionLinks/read/url"),
        "record_type": record_type,
    }

    # Extraction of record specific metadata
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