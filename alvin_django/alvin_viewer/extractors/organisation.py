from lxml import etree
from .common import authority_names, variant_names_list, electronic_locators, dates
from .mappings import organisation

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
        "authority_names": authority_names(root, organisation["AUTH_NAME"]),
        "variant_names": variant_names_list(root, organisation["VARIANT"]),
        "organisation_info": dates(root, "organisation/organisationInfo", "start", "end"),
        "display_date": root.findtext(".//displayDate"),
        "notes": notes_map,
        "identifiers": identifiers_map,
        "address": address,
        "electronic_locators": electronic_locators(root, "electronicLocator"),
        "related_organisations": related_orgs,
    }