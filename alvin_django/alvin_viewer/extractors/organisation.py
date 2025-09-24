from lxml import etree
from .common import authority_names, variant_names_list, electronic_locators, get_dates, get_date_other

AUTH_NAME = {
    "corporate_name": "./name/namePart[@type='corporateName']",
    "subordinate_name": "./name/namePart[@type='subordinate']",
    "terms_of_address": "./name/namePart[@type='termsOfAddress']",
    "orientation_code": "./name/orientationCode",
    "variant_type": "variantType",
}

VARIANT = {
    "language": "./@lang",
    "corporate_name": "./name/namePart[@type='corporateName']",
    "subordinate_name": "./name/namePart[@type='subordinate']",
    "terms_of_address": "./name/namePart[@type='termsOfAddress']",
    "orientation_code": "./name/orientationCode",
    "variant_type": "./@variantType",
}

def extract(root: etree._Element) -> dict:
    notes_map = {n.get("noteType"): n.findtext(".") for n in root.xpath("//note")}
    identifiers_map = {i.get("type"): i.findtext(".") for i in root.xpath("//identifier")}
    related_orgs = [{
        "type": r.get("type"),
        "id": r.findtext(".//linkedRecordId"),
        "url": r.findtext(".//url"),
    } for r in root.xpath("//related")]

    address = {
        "box": root.findtext(".//address/postOfficeBox"),
        "street": root.findtext(".//address/street"),
        "postcode": root.findtext(".//address/postcode"),
        "place_id": root.findtext(".//address/place//linkedRecordId"),
        "country": root.findtext(".//address/country"),
    }

    return {
        "authority_names": authority_names(root, AUTH_NAME),
        "variant_names": variant_names_list(root, VARIANT),
        "start_date": get_dates("start", root),
        "end_date": get_dates("end", root),
        "display_date": root.findtext(".//displayDate"),
        "notes": notes_map,
        "identifiers": identifiers_map,
        "address": address,
        "electronic_locators": electronic_locators(root),
        "related_organisations": related_orgs,
    }