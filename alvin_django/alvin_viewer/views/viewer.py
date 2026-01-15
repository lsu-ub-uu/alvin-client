from django.conf import settings
from django.http import Http404
from django.shortcuts import render
from lxml import etree

from ..services.alvin_api import AlvinAPI
from ..extractors import person, place, organisation, work, record
from ..extractors.common import common
from ..xmlutils.nodes import text, elements

EXTRACTORS = {
    "alvin-person": person.extract,
    "alvin-place": place.extract,
    "alvin-organisation": organisation.extract,
    "alvin-work": work.extract,
    "alvin-record": record.extract,
}

def extract_metadata(root: etree._Element, record_type: str) -> dict:
    
    extractor = EXTRACTORS.get(record_type)
    if not extractor:
        raise Http404("Invalid record type")
    common_data = common(root, record_type)
    data = extractor(root)
    return {**common_data, **data}

def alvin_viewer(request, record_type: str, record_id: str):
    value = request.GET.get("data", None)
    api = AlvinAPI()
    root = api.get_record_xml(record_type, record_id)
    metadata = extract_metadata(root, record_type)
    # Disabled for debugging purposes
    '''try:
        root = api.get_record_xml(record_type, record_id)
        metadata = extract_metadata(root, record_type)
    except Exception as e:
        raise Http404(str(e))'''
    context = {"metadata": metadata, "value": value}
    return render(request, "alvin_viewer/alvin_viewer.html", context)