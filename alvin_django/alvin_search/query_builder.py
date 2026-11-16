import json
from urllib.parse import quote
from typing import List, Tuple
from .metadata import SearchParams


def _build_children(raw_terms: List[Tuple[str, str]]) -> List[dict]:
    """Filters empty values and create Cora's name/value pairs"""
    return [{"name": name, "value": val} for name, val in raw_terms if val]


def build_cora_search_url(api_host: str, params: SearchParams, start: int, rows: int, view: str) -> str:
    p = params

    search_configs = {
        'alvinRecord': [
            ("alvinRecordSearchTerm", p.query),
            ("locationInRecordSearchTerm", f"alvin-location_{p.location}" if p.location else ""),
            ("personInRecordSearchTerm", f"alvin-person_{p.person}" if p.person else ""),
            ("organisationInRecordSearchTerm", f"alvin-organisation_{p.organisation}" if p.organisation else ""),
            ("placeInRecordSearchTerm", f"alvin-place_{p.place}" if p.place else ""),
            ("workInRecordSearchTerm", f"alvin-work_{p.work}" if p.work else ""),
            ("alvinRecordIdSearchTerm", p.id),
            ("subjectSearchTerm", p.subject),
            ("alvinRecordTypeSearchTerm", p.type),
            ("productionMethodSearchTerm", p.production),
            ("genreFormSearchTerm", p.genre),
            ("appliedMaterialSearchTerm", p.technique),
            ("baseMaterialSearchTerm", p.material),
            ("rightsSearchTerm", p.right),
            ("alvinRecordTitleSearchTerm", p.title),
            ("countryCodeSearchTerm", p.country),
            ("yearSearchTerm", p.year),
            ("subcollectionSearchTerm", p.subcollection),
            ("languageCodeSearchTerm", p.language),
            ("historicalCountrySearchTerm", p.historical),
            ("identifierSearchTerm", p.identifier),
            ("shelfmarkSearchTerm", p.shelfmark),
            ("publicationSearchTerm", p.publication),
            ("relatorCodeSearchTerm", p.role),
            ("collectionTypeOfResourceSearchTerm", "yes" if p.collection == "yes" else ""),
            ("digitalOriginSearchTerm", "reformattedDigital" if p.digital == "yes" else ""),
            ("visibilityAlvinSearchTerm", "published"),
        ],
        'person': [
            ("personSearchTerm", p.query),
            ("personNameSearchTerm", p.name),
            ("personNationalitySearchTerm", p.country),
            ("personRecordIdSearchTerm", p.id),
            ("yearPersonSearchTerm", p.year),
            ("placeInPersonSearchTerm", f"alvin-place_{p.place}" if p.place else ""),
            ("personOccupationSearchTerm", p.occupation),
            ("personSexSearchTerm", p.gender),
            ("identifierPersonSearchTerm", p.identifier),
            ("familyNameSearchTerm", "yes" if p.family == "yes" else ""),
        ],
        'organisation': [
            ("organisationSearchTerm", p.query),
            ("organisationNameSearchTerm", p.name),
            ("organisationRecordIdSearchTerm", p.id),
            ("organisationCountrySearchTerm", p.country),
            ("identifierOrganisationSearchTerm", p.identifier),
            ("yearOrganisationSearchTerm", p.year),
        ],
        'place': [
            ("placeSearchTerm", p.query),
            ("placeNameSearchTerm", p.name),
            ("placeCountrySearchTerm", p.country),
            ("placeRecordIdSearchTerm", p.id),
        ],
        'work': [
            ("workSearchTerm", p.query),
            ("workFormOfWorkSearchTerm", p.form),
            ("workTitleSearchTerm", p.title),
            ("workCreationDateSearchTerm", p.year),
            ("workRecordIdSearchTerm", p.id),
            ("workCountrySearchTerm", p.country),
        ],
    }

    if p.searchType not in search_configs:
        raise ValueError(f"Invalid searchType: {p.searchType}")

    include_part_children = _build_children(search_configs[p.searchType])

    payload = {
        "name": f"{p.searchType}Search",
        "children": [
            {
                "name": "include",
                "children": [
                    {
                        "name": "includePart",
                        "children": include_part_children,
                    }
                ],
            },
            {"name": "start", "value": str(start)},
            {"name": "rows", "value": str(rows)},
        ],
    }

    search_data_json = json.dumps(payload, separators=(',', ':'))
    return f"{api_host}/rest/record/searchResult/{p.searchType}Search?searchData={search_data_json}&view={view}"
