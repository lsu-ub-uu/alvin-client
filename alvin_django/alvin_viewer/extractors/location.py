from lxml import etree

from .records import AlvinLocation
from .metadata import Address, Summary
from .common import _get_label, _norm_rt, _xp, attr, dates, decorated_list_item, decorated_text, electronic_locators, element, elements, identifiers, names, origin_place, related_authority, text
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

    address = Address(
        label = _get_label(element(root, _xp(rt, "address"))),
        box = decorated_text(root, _xp(rt, "address/postOfficeBox")),
        street = text(root, _xp(rt, "address/street")),
        postcode = text(root, _xp(rt, "address/postcode")),
        place = origin_place(root, _xp(rt, "address")),
        country = decorated_list_item(root, _xp(rt, "address/country"))
    )

    return AlvinLocation(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type = "alvin-location",
        source_xml = text(root, "actionLinks/read/url"),
        created = decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        label = _get_label(element(root, "data/location")),
        authority_names = names(root, _xp(rt, "authority"), organisation["AUTH_NAME"]),
        dates = dates(root, _xp(rt, "organisationInfo"), "start", "end"),
        display_date=decorated_text(root, _xp(rt, "organisationInfo/displayDate")),
        member_type=decorated_list_item(root, _xp(rt, "organisationInfo/descriptor")),
        email = decorated_text(root, _xp(rt, "email")),
        summary = summary(root, _xp(rt, "summary")),
        address = address,
        latitude = decorated_text(root, _xp(rt, "point/latitude")),
        longitude = decorated_text(root, _xp(rt, "point/longitude")),
        electronic_locators = electronic_locators(root, _xp(rt, "electronicLocator")),
    )