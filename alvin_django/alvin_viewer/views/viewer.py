from django.conf import settings
from django.http import Http404, HttpResponse
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
        """
        Checks recursively if any components has related records 
        
        """

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
    value = request.GET.get("data", None) #Value saved from search
    api = AlvinAPI()
    root = api.get_record_xml(record_type, record_id)
    metadata = extract_metadata(root, record_type)
    
    #Thumbnail pagination for the download menu
    all_images = metadata.files.get_images if record_type == 'alvin-record' and getattr(metadata.files, 'has_images', False) else []
    paginator = Paginator(all_images, 10)
    page_number = request.GET.get('page', 1)
    page_obj = paginator.get_page(page_number)
    
    # Download menu tabs configuration
    download_tabs = {
        "default_download_tab": "show_metadata",
        "tabs": []
    }

    if metadata.record_type == 'alvin-record':
        if metadata.files and getattr(metadata.files, 'has_images', False):
            download_tabs["tabs"].append({"id": "show_thumbnails", "label": "Bilder"})

        if getattr(metadata.files, 'has_attachments', False):
            download_tabs["tabs"].append({"id": "show_attachments", "label": "Dokument"})

        download_tabs["tabs"].append({"id": "show_metadata", "label": "Metadata"})

        if download_tabs["tabs"]:
            download_tabs["default_download_tab"] = download_tabs["tabs"][0]["id"]

    else:
        download_tabs["tabs"] = [{"id": "show_metadata", "label": "Metadata"}]
        download_tabs["default_download_tab"] = "show_metadata"

    # Handling HTMX for loading related records by category
    load_category = request.GET.get('load_category')
    load_component_category = request.GET.get('load_component_category')
    category_page_number = request.GET.get('rel_page', 1)

    def _render_category_block(related_records, category_request, htmx_get_param, htmx_target_name):
        for block in related_records:
            if block.label == category_request:
                paginator = Paginator(block.records, 1)
                category_page_obj = paginator.get_page(category_page_number)

                return render(request, 'alvin_viewer/_partials/_paged_related_category.html', {
                    'type_block': block,
                    'category_page_obj': category_page_obj,  # <-- Nytt namn!
                    'htmx_get': htmx_get_param,
                    'htmx_target': htmx_target_name,
                    })

        return HttpResponse(status=204)

    if load_category and hasattr(metadata, 'related_records') and metadata.related_records:
        records = metadata.related_records.ordered_by_type()
        return _render_category_block(records, load_category, 'load_category', 'category')

    if load_component_category and getattr(metadata, 'components', None) and getattr(metadata.components, 'all_related_records', None):
        component_records = metadata.components.all_related_records.ordered_by_type()
        return _render_category_block(component_records, load_component_category, 'load_component_category', 'component-category')

    # Disabled for debugging purposes
    '''try:
        root = api.get_record_xml(record_type, record_id)
        metadata = extract_metadata(root, record_type)
    except Exception as e:
        raise Http404(str(e))'''
    
    context = {"metadata": metadata, 
               "value": value,
               "has_related": has_related(metadata),
               "has_all_metadata": has_all_metadata(metadata),
               "page_obj": page_obj, 
               "download_tabs": download_tabs }

    if request.headers.get('HX-Request') and 'page' in request.GET:
        return render(request, 'alvin_viewer/_partials/_thumbnail_page.html', context)
    return render(request, "alvin_viewer/alvin_viewer.html", context)