from lxml import etree

from .common import _get_label, _norm_rt, _xp, compact, decorated_list_item, decorated_text, element, names
from .mappings import place
from .cleaner import clean_empty

rt = _norm_rt("alvin-place")

def extract(root: etree._Element) -> dict:
    data = compact({
        "label": _get_label(element(root, "data/place")),
        "authority_names": names(root,  _xp(rt, "authority"), place["AUTH_NAME"]),
        "variant_names": names(root, _xp(rt, "variant"), place["VARIANT"]),
        "country": decorated_list_item(root, _xp(rt, "country")),
        "latitude": decorated_text(root, _xp(rt, "point/latitude")),
        "longitude": decorated_text(root, _xp(rt, "point/longitude"))
    })
    
    return clean_empty(data)