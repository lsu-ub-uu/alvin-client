import json
from urllib.parse import quote
from django.shortcuts import render, redirect
from django.http import Http404
from django.conf import settings
from django.utils import translation
from django.core.cache import cache

from services.text_collector import get_item_dict
from services.alvin_api import AlvinAPI

from .metadata import SearchParams
from .query_builder import build_cora_search_url
from .extractors import extract_records_from_xml, EXTRACTOR_REGISTRY

ITEMS_DICT = get_item_dict()
api = AlvinAPI()
api_host = settings.EXTERNAL_ACCESS_URL

# Static metadata collections
COLLECTION_KEYS = {
    "resourceTypes": "typeOfResourceCollection",
    "productions": "productionMethodCollection",
    "genres": "genreCollection",
    "techniques": "appliedMaterialCollection",
    "materials": "baseMaterialCollection",
    "rights": "rightsCollection",
    "forms": "formOfWorkCollection",
    "languages": "languageCollection",
    "countries": "countryCollection",
    "historicalCountries": "historicalCountryCollection",
    "subcollections": "subcollectionCollection",
    "roles": "roleCollection",
    "genders": "genderCollection",
}


FILTER_PREFIXES = {
    'person': 'Person',
    'organisation': 'Organisation',
    'place': 'Plats',
    'work': 'Verk',
    'id': 'ID',
}


STATIC_FILTER_LABELS = {
    'digital': 'Digital version',
    'collection': 'Samlingspost',
    'family': 'Släkt',
}

# Maps get param to key in collection dictionary
PARAM_TO_COLLECTION = {
    'type': 'resourceTypes',
    'form': 'forms',
    'production': 'productions',
    'language': 'languages',
    'country': 'countries',
    'historical': 'historicalCountries',
    'genre': 'genres',
    'technique': 'techniques',
    'material': 'materials',
    'role': 'roles',
    'subcollection': 'subcollections',
    'right': 'rights',
    'gender': 'genders',
}


def get_locations() -> list:
    cached_locations = cache.get('alvin_locations_list')
    if cached_locations is not None:
        return cached_locations
    list_url = f'{api_host}/rest/record/alvin-location'
    xml_headers_list = {
        'Content-Type': 'application/vnd.cora.recordList+xml',
        'Accept': 'application/vnd.cora.recordList+xml',
    }
    try:
        resp = api.session.get(list_url, headers=xml_headers_list, timeout=(3, 15))
        resp.raise_for_status()
        xml_list = api._parse_xml(resp.content)
        return [
            {
                'identifier': loc.findtext('./recordInfo/id'),
                'nameone': loc.findtext('./authority[1]/name/namePart[1]'),
            }
            for loc in xml_list.findall('data/record/data/location')
        ]
    except Exception:
        raise Http404("Locations not found")


def item_collector(collection: str) -> dict:
    data = ITEMS_DICT.get(collection)
    if not data:
        raise Http404(f"No list found for {collection}.")
    current_lang = translation.get_language()
    if current_lang not in ('sv', 'en', 'no'):
        current_lang = 'sv'
    return dict(sorted(data.items(), key=lambda item: item[1].get(current_lang, '').strip()))


def get_active_filters(request, locations: list, collections: dict) -> list:
    active_filters = []
    ignored_params = {'searchType', 'view', 'start', 'rows', 'page'}
    lang = translation.get_language()

    location_map = {loc.get('identifier'): loc.get('nameone') for loc in locations}

    for key, value in request.GET.items():
        if not value or key in ignored_params or (key == 'query' and value == '**'):
            continue

        params = request.GET.copy()
        params.pop(key, None)
        remove_url = f"{request.path}?{params.urlencode()}" if params else request.path

        prefix = FILTER_PREFIXES.get(key)
        label = STATIC_FILTER_LABELS.get(key, value)

        if key == 'location':
            label = location_map.get(value, value)
        elif key in PARAM_TO_COLLECTION:
            col_dict = collections.get(PARAM_TO_COLLECTION[key], {})
            label = col_dict.get(value, {}).get(lang, value)

        active_filters.append({
            'key': key,
            'prefix': prefix,
            'label': label,
            'remove_url': remove_url,
        })

    return active_filters


def alvin_search(request):
    
    # Clean params if empty
    if any(v == '' or (k == 'query' and v == '**') for k, v in request.GET.items()):
        cleaned = request.GET.copy()
        for k, v in list(cleaned.items()):
            if v == '' or (k == 'query' and v == '**'):
                cleaned.pop(k)
        qs = cleaned.urlencode()
        return redirect(f"{request.path}?{qs}" if qs else request.path)

    # Load params into dataclass
    search_params = SearchParams.from_querydict(request.GET)
    if search_params.searchType not in EXTRACTOR_REGISTRY:
        raise Http404("Invalid search type")

    # Get list filters
    locations = get_locations()
    collections = {key: item_collector(col_name) for key, col_name in COLLECTION_KEYS.items()}

    # Pagination
    startnum = int(request.GET.get('start') or 1)
    rowsnum = int(request.GET.get('rows') or 20)
    view = request.GET.get('view', 'list')

    view_params = request.GET.copy()
    view_params.pop('view', None)
    view_params.pop('start', None)
    view_url = f"{request.path}?{view_params.urlencode()}" if view_params else request.path

    # Build Cora URL and get XML
    list_url = build_cora_search_url(api_host, search_params, startnum, rowsnum, view)
    xml_headers_search = {
        'Content-Type': 'application/vnd.cora.recordList-decorated+xml',
        'Accept': 'application/vnd.cora.recordList-decorated+xml',
    }
    try:
        resp = api.session.get(list_url, headers=xml_headers_search, timeout=(3, 15))
        resp.raise_for_status()
        xml_list = api._parse_xml(resp.content)
    except Exception as e:
        raise Http404(f"Invalid search: {e}")

    # 6. Extrahera poster till dataklasser via vårt registry
    records = extract_records_from_xml(search_params.searchType, xml_list)

    # 7. Beräkna träffar och sidnumrering
    complete_list_size = int(xml_list.findtext(".//totalNo") or 0)
    cursor = int(xml_list.findtext(".//toNo") or 0)

    context = {
        **search_params.to_context_dict(),
        **collections,
        "records": records,
        "locations": locations,
        "completeListSize": complete_list_size,
        "startnum": startnum,
        "rowsnum": rowsnum,
        "nextstartnum": startnum + rowsnum,
        "prevstartnum": startnum - rowsnum,
        "cursor": cursor,
        "encoded_link": quote(request.get_full_path(), safe=''),
        "view": view,
        "view_url": view_url,
        "json_safe_str": json.dumps(search_params.query),
        "api_host": api_host,
        "external_access_url": settings.EXTERNAL_ACCESS_URL,
        "lang": request.LANGUAGE_CODE,
        "current_lang": translation.get_language(),
        "active_filters": get_active_filters(request, locations, collections),
    }

    return render(request, 'alvin_search/alvin_search.html', context)
