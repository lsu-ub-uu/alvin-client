from lxml import etree

from .metadata import DateEntry

from .records import AlvinPerson
from ..xmlutils.nodes import attr, text
from .common import (_get_label, _get_target, _norm_rt, _xp, a_date, 
                     decorated_list_item, electronic_locators, element, decorated_list, 
                     decorated_text, decorated_texts, decorated_texts_with_type, identifiers, names, origin_place, 
                     related_authority)
from .mappings import person

rt = _norm_rt("alvin-person")

def _nationality(root: etree._ElementTree, xp: str) -> dict:
    target = _get_target(root, xp)
    if target is None:
        return None
    return {
        "label": _get_label(target),
        "country": decorated_list(root, f"{xp}/country")
    }

def _person_date(root: etree._ElementTree, xp: str, kind: str) -> DateEntry:
    target = _get_target(root, xp)
    if target is None:
        return None
    return a_date(target, kind)

def extract(root: etree._Element) -> AlvinPerson:
    
    return AlvinPerson(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type = "alvin-person",
        source_xml = text(root, "actionLinks/read/url"),
        created = decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        label = _get_label(element(root, "data/person")),
        authority_names = names(root, _xp(rt, "authority"), person["AUTH_NAME"]),
        variant_names = names(root, _xp(rt, "variant"), person["AUTH_NAME"]),
        birth_date = _person_date(root, _xp(rt, "personInfo"), "birth"),
        death_date = _person_date(root, _xp(rt, "personInfo"), "death"),
        display_date = decorated_text(root, _xp(rt, "personInfo/displayDate")),
        birth_place = origin_place(root, _xp(rt,"personInfo/birthPlace")),
        death_place = origin_place(root, _xp(rt,"personInfo/deathPlace")),
        nationality = _nationality(root, _xp(rt, "personInfo/nationality")),
        gender = decorated_list_item(root, _xp(rt, "personInfo/gender")),
        fields_of_endeavor = decorated_texts(root, _xp(rt, "fieldOfEndeavor")),
        notes = decorated_texts_with_type(root, _xp(rt, "note"), ".", "noteTypeCollection", "./@noteType"),
        identifiers = identifiers(root, _xp(rt, "identifier")),
        electronic_locators = electronic_locators(root, _xp(rt, "electronicLocator")),
        related_persons = related_authority(root, _xp(rt, "related[person]"), "person"),
        related_organisations = related_authority(root, _xp(rt, "related[organisation]"), "organisation"),
    )