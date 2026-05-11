from django.conf import settings
from django.http import Http404
from django.core.paginator import Paginator
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
    "electronic_locators",
    "subject_person", "subject_organisation", "subject_place", "related_persons", 
    "related_organisations", "work"
    ]

    if any(getattr(metadata, attr, None) for attr in attrs):
        return True
     
    def _check_components(components):
        for component in components:
            if any(getattr(component, attr, None) for attr in attrs):
                return True
            sub_components = getattr(component, "components", None)
            if sub_components:
                if _check_components(sub_components):
                    return True

    components = getattr(metadata, "components", None)
    if components:
        return _check_components(components)     
            
    return False

def has_all_metadata(metadata) -> bool:
    attrs = [
        # Common, AlvinRecord
        "variant_titles", "edition_statement", "publications", "date_other",
        "languages", "sublocation", "shelf_mark", "former_shelf_mark",
        "subcollection", "physical_location_note", "base_material",
        "applied_material", "extent", "dimensions", "measure",
        "physical_description_notes", "notes", "transcription",
        "table_of_contents", "literature", "access_policy",
        "genre_form", "classifications", "identifiers", "deco_note",
        "binding", "binding_deco_note",
        "level", "shelf_metres", "archival_units",
        "other_findaid", "weeding", "related_material", "arrangement",
        "accruals", "locus", "incipit", "explicit", "rubric",
        "final_rubric", "music_key", "music_key_other", "music_medium",
        "music_medium_other", "music_notation", "scale", "projection",
        "coordinates", "appraisal", "edge", "axis", "conservation_state",
        "obverse", "reverse", "countermark",
        
        # AlvinPerson, AlvinPlace, AlvinOrganisation, AlvinLocation, AlvinWork
        "variant_names", "nationality", "gender",
        "fields_of_endeavor", "address", "dates", "member_type", "email",
        "serial_number", "opus_number", "thematic_number",
        "country", "latitude", "longitude"
    ]

    if any(getattr(metadata, attr, None) for attr in attrs):
        return True
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
    context = {"metadata": metadata, "value": value, "has_related": has_related(metadata), "has_all_metadata": has_all_metadata(metadata)}
    return render(request, "alvin_viewer/alvin_viewer.html", context)

