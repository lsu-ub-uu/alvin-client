from lxml import etree
from .common import authority_names, variant_names_list, electronic_locators, related, dates, a_date
from .mappings import person
from .cleaner import clean_empty

def extract(root: etree._Element) -> dict:
    md = {
        "authority_names": authority_names(root, person["AUTH_NAME"]),
        "variant_names": variant_names_list(root, person["VARIANT"]),
        "person_info": dates(root, "person", "personInfo", "birth", "death"),
        "birth_place": root.findtext(".//birthPlace//linkedRecordId"),
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
    
    return clean_empty(md)