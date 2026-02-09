from django.conf import settings
from django.http import Http404
from django.shortcuts import render
from lxml import etree

from ..services.alvin_api import AlvinAPI
from ..extractors import location, person, place, organisation, record, work 

EXTRACTORS = {
    "alvin-person": person.extract,
    "alvin-place": place.extract,
    "alvin-organisation": organisation.extract,
    "alvin-location": location.extract,
    "alvin-work": work.extract,
    "alvin-record": record.extract,
}

def extract_metadata(root: etree._Element, record_type: str):
    
    extractor = EXTRACTORS.get(record_type)
    if not extractor:
        raise Http404("Invalid record type")
    return extractor(root)

def has_related(metadata) -> bool:
    
    attrs = [
    "agents", "location", "origin_places", "related_records", "electronic_locators",
    "subject_person", "subject_organisation", "birth_place", "death_place", "related_persons", 
    "related_organisations", "subject_place", "work",
    ]

    if any(getattr(metadata, attr, None) for attr in attrs):
        return True
     
    def _check_components(components):
        for component in components:
            if any(getattr(component, attr, None) for attr in attrs):
                return True
            sub_components = getattr(component, "components", None)
            if sub_components:
                if _check_components(sub_components): # Viktigt: returnera True om träff hittas!
                    return True

    components = getattr(metadata, "components", None)
    if components:
        return _check_components(components)     
            
    return False

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
    context = {"metadata": metadata, "value": value, "has_related": has_related(metadata)}
    return render(request, "alvin_viewer/alvin_viewer.html", context)