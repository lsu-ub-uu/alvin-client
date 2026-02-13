from lxml import etree

from .records import AlvinOrganisation
from .metadata import Address
from .common import _get_label, _norm_rt, _xp, compact, dates, first, decorated_list_item, decorated_text, decorated_texts_with_type, electronic_locators, element, identifiers, names, origin_place, related_authority, text
from .mappings import organisation

rt = _norm_rt("alvin-organisation")

def extract(root: etree._Element) -> AlvinOrganisation:

    address = Address(
        label = _get_label(element(root, _xp(rt, "address"))),
        box = decorated_text(root, _xp(rt, "address/postOfficeBox")),
        street = text(root, _xp(rt, "address/street")),
        postcode = text(root, _xp(rt, "address/postcode")),
        place = origin_place(root, _xp(rt, "address")),
        country = decorated_list_item(root, _xp(rt, "address/country"))
    )

    return AlvinOrganisation(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type = "alvin-organisation",
        source_xml = text(root, "actionLinks/read/url"),
        created = decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        label = _get_label(element(root, "data/organisation")),
        authority_names = names(root, _xp(rt, "authority"), organisation["AUTH_NAME"]),
        variant_names = names(root, _xp(rt, "variant"), organisation["VARIANT"]),
        organisation_info = dates(root, _xp(rt, "organisationInfo"), "start", "end"),
        display_date = decorated_text(root, _xp(rt, "organisationInfo/displayDate")),
        notes = decorated_texts_with_type(root, _xp(rt, "note"), ".", "./@noteType"),
        identifiers = identifiers(root, _xp(rt, "identifier")),
        address = address,
        electronic_locators = electronic_locators(root, _xp(rt, "electronicLocator")),
        related_organisations = related_authority(root, _xp(rt, "related"), "organisation")
    )