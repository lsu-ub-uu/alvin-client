from lxml import etree

from .records import AlvinLocation
from .metadata import Summary
from .common import _get_label, _norm_rt, _xp, address, attr, date, decorated_list_item, decorated_text, electronic_locators, element, elements, identifiers, names, origin_place, related_authority, text
from .mappings import organisation

rt = _norm_rt("alvin-location")

def summary(root: etree.Element, xp: str) -> Summary | None:
    targets = elements(root, xp)
    if targets is None:
        return None
    
    texts = {}
    for t in targets:
        texts.update({attr(t, "./@lang"): text(t, ".")})

    summary = Summary(
        label = _get_label(element(root, xp)),
        texts = texts
    )

    if summary.is_empty():
        return None
    return summary

def extract(root: etree._Element) -> AlvinLocation:

    return AlvinLocation(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type = "alvin-location",
        created = decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        label = _get_label(element(root, "data/location")),
        authority_names = names(root, _xp(rt, "authority"), organisation["AUTH_NAME"]),
        start_date = date(root, _xp(rt, "organisationInfo"), "start"),
        end_date = date(root, _xp(rt, "organisationInfo"), "end"),
        display_date=decorated_text(root, _xp(rt, "organisationInfo/displayDate")),
        member_type=decorated_list_item(root, _xp(rt, "organisationInfo/descriptor")),
        email = decorated_text(root, _xp(rt, "email")),
        summary = summary(root, _xp(rt, "summary")),
        address = address(root, rt),
        latitude = decorated_text(root, _xp(rt, "point/latitude")),
        longitude = decorated_text(root, _xp(rt, "point/longitude")),
        electronic_locators = electronic_locators(root, _xp(rt, "electronicLocator")),
    )