from lxml import etree

from .records import AlvinPlace

from .common import _get_label, _norm_rt, _xp, compact, decorated_list_item, decorated_text, element, names, text
from .mappings import place

rt = _norm_rt("alvin-place")

def extract(root: etree._Element) -> AlvinPlace:

    return AlvinPlace(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type="alvin-place",
        source_xml = text(root, "actionLinks/read/url"),
        created = decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        last_updated = decorated_text(root, _xp(rt, "recordInfo/updated/tsUpdated[last()]")),
        label =_get_label(element(root, "data/place")),
        authority_names = names(root,  _xp(rt, "authority"), place["AUTH_NAME"]),
        variant_names = names(root, _xp(rt, "variant"), place["VARIANT"]),
        country = decorated_list_item(root, _xp(rt, "country")),
        latitude = decorated_text(root, _xp(rt, "point/latitude")),
        longitude = decorated_text(root, _xp(rt, "point/longitude")),
    )