from lxml import etree

from .records import AlvinPerson
from ..xmlutils.nodes import text
from .common import (_get_label, _get_target, _norm_rt, _xp, date,
                     decorated_list_item, electronic_locators, element, decorated_list, note_and_type,
                     decorated_text, decorated_texts, identifiers, names, origin_place, 
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

def extract(root: etree._Element) -> AlvinPerson:
    
    return AlvinPerson(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type = "alvin-person",
        created = decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        label = _get_label(element(root, "data/person")),
        authority_names = names(root, _xp(rt, "authority"), person["AUTH_NAME"]),
        variant_names = names(root, _xp(rt, "variant"), person["AUTH_NAME"], "variantPersonNameTypeCollection"),
        birth_date = date(root, _xp(rt, "personInfo"), "birth"),
        death_date = date(root, _xp(rt, "personInfo"), "death"),
        display_date = decorated_text(root, _xp(rt, "personInfo/displayDate")),
        birth_place = origin_place(root, _xp(rt,"personInfo/birthPlace")),
        death_place = origin_place(root, _xp(rt,"personInfo/deathPlace")),
        nationality = _nationality(root, _xp(rt, "personInfo/nationality")),
        gender = decorated_list_item(root, _xp(rt, "personInfo/gender")),
        fields_of_endeavor = decorated_texts(root, _xp(rt, "fieldOfEndeavor")),
        biographical_note = note_and_type(root, _xp(rt, "note[@noteType = 'biographicalHistorical']"), "noteTypeCollection", "biographicalHistorical"),
        general_note = note_and_type(root, _xp(rt, "note[@noteType = 'general']"), "noteTypeAuthorityCollection", "general"),
        source_note = note_and_type(root, _xp(rt, "note[@noteType = 'sourceData']"), "noteTypeAuthorityCollection", "sourceData"),
        identifiers = identifiers(root, _xp(rt, "identifier")),
        electronic_locators = electronic_locators(root, _xp(rt, "electronicLocator")),
        related_persons = related_authority(root, _xp(rt, "related[person]"), "person"),
        related_organisations = related_authority(root, _xp(rt, "related[organisation]"), "organisation"),
    )