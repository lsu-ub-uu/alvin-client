from lxml import etree
from .common import (_get_label, _get_target, _norm_rt, _xp, a_date, compact, 
                     decorated_list_item, electronic_locators, element, decorated_list, 
                     decorated_text, decorated_texts, decorated_texts_with_type, first, identifiers, names, origin_places, 
                     related_authority)
from .mappings import person
from .cleaner import clean_empty
from django.core.cache import cache
from ..services.text_collector import get_item_dict


rt = _norm_rt("alvin-person")

def _nationality(root: etree._ElementTree, xp: str) -> dict:
    target = _get_target(root, xp)
    if target is None:
        return None
    return {
        "label": _get_label(target),
        "country": decorated_list(root, f"{xp}/country")
    }

def _person_date(root: etree._ElementTree, xp: str, kind: str):
    target = _get_target(root, xp)
    if target is None:
        return None
    return a_date(target, kind)

def extract(root: etree._Element) -> dict:
    
    md = compact({
        "label": _get_label(element(root, "data/person")),
        "authority_names": names(root, _xp(rt, "authority"), person["AUTH_NAME"]),
        "variant_names": names(root, _xp(rt, "variant"), person["AUTH_NAME"]),
        "birth_date": _person_date(root, _xp(rt, "personInfo"), "birth"),
        "birth_place": first(origin_places(root, _xp(rt,"personInfo/birthPlace"))),
        "death_date": _person_date(root, _xp(rt, "personInfo"), "death"),
        "death_place": first(origin_places(root, _xp(rt,"personInfo/deathPlace"))),
        "display_date": decorated_text(root, _xp(rt, "personInfo/displayDate")),
        "nationality": _nationality(root, _xp(rt, "personInfo/nationality")),
        "gender": decorated_list_item(root, _xp(rt, "personInfo/gender")),
        "fields_of_endeavor": decorated_texts(root, _xp(rt, "fieldOfEndeavor")),
        "notes": decorated_texts_with_type(root, _xp(rt, "note"), ".", "./@noteType"),
        "identifiers": identifiers(root, _xp(rt, "identifier")),
        "electronic_locators": electronic_locators(root, _xp(rt, "electronicLocator")),
        "related_persons": related_authority(root, _xp(rt, "related[person]"), "person"),
        "related_organisations": related_authority(root, _xp(rt, "related[organisation]"), "organisation"),
    })
    
    return clean_empty(md)