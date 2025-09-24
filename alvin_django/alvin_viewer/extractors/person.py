from lxml import etree
from .common import authority_names, variant_names_list, electronic_locators, related, get_dates, get_date_other

AUTH_NAME = {
    "family_name": "./name/namePart[@type='family']",
    "given_name": "./name/namePart[@type='given']",
    "numeration": "./name/namePart[@type='numeration']",
    "terms_of_address": "./name/namePart[@type='termsOfAddress']",
    "orientation_code": "./name/orientationCode",
    "variant_type": "variantType",
}

VARIANT = {
    "language": "./@lang",
    "family_name": "./name/namePart[@type='family']",
    "given_name": "./name/namePart[@type='given']",
    "numeration": "./name/namePart[@type='numeration']",
    "terms_of_address": "./name/namePart[@type='termsOfAddress']",
    "orientation_code": "./name/orientationCode",
    "variant_type": "variantType",
}

def extract(root: etree._Element) -> dict:
    return {
        "authority_names": authority_names(root, AUTH_NAME),
        "variant_names": variant_names_list(root, VARIANT),
        "birth_date": get_dates("birth", root),
        "birth_place": root.findtext(".//birthPlace//linkedRecordId"),
        "death_date": get_dates("death", root),
        "death_place": root.findtext(".//deathPlace//linkedRecordId"),
        "display_date": root.findtext(".//displayDate"),
        "nationality": [n.findtext("./country") for n in root.xpath("//nationality")],
        "gender": root.findtext(".//gender"),
        "fields_of_endeavor": [f.findtext(".") for f in root.xpath("//fieldOfEndeavor")],
        "notes": {note.get("noteType"): note.findtext(".") for note in root.xpath("//note")},
        "identifiers": {i.get("type"): i.findtext(".") for i in root.xpath("//identifier")},
        "electronic_locators": electronic_locators(root),
        "related_persons": related(root, "person"),
        "related_organisations": related(root, "organisation"),
    }