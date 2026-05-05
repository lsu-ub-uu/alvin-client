from lxml import etree

from .records import AlvinOrganisation
from .metadata import Address
from .common import _get_label, _norm_rt, _xp, address, date, decorated_list_item, decorated_text, note_and_type, electronic_locators, element, identifiers, names, origin_place, related_authority, text
from .mappings import organisation

rt = _norm_rt("alvin-organisation")

def extract(root: etree._Element) -> AlvinOrganisation:

    return AlvinOrganisation(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type = "alvin-organisation",
        created = decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        label = _get_label(element(root, "data/organisation")),
        authority_names = names(root, _xp(rt, "authority"), organisation["AUTH_NAME"]),
        variant_names = names(root, _xp(rt, "variant"), organisation["VARIANT"], "variantOrganisationNameTypeCollection"),
        start_date = date(root, _xp(rt, "organisationInfo"), "start"),
        end_date = date(root, _xp(rt, "organisationInfo"), "end"),
        display_date = decorated_text(root, _xp(rt, "organisationInfo/displayDate")),
        biographical_note = note_and_type(root, _xp(rt, "note[@noteType = 'biographicalHistorical']"), "noteTypeCollection", "biographicalHistorical"),
        general_note = note_and_type(root, _xp(rt, "note[@noteType = 'general']"), "noteTypeCollection", "general"),
        source_note = note_and_type(root, _xp(rt, "note[@noteType = 'sourceData']"), "noteTypeAuthorityCollection", "sourceData"),
        identifiers = identifiers(root, _xp(rt, "identifier")),
        address = address(root, rt),
        electronic_locators = electronic_locators(root, _xp(rt, "electronicLocator")),
        related_organisations = related_authority(root, _xp(rt, "related"), "organisation", "relatedOrganisationTypeCollection")
    )