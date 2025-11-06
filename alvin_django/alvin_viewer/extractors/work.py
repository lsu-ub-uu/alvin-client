from lxml import etree
from .common import _get_label, _get_value, _norm_rt, _xp, agents, compact, dates, decorated_text, decorated_list_item, electronic_locators, first, origin_places, titles
from ..xmlutils.nodes import text, attr, element, elements
from .cleaner import clean_empty

rt = _norm_rt("alvin-work")

def extract(root: etree._Element) -> dict:
    data = compact({
        "label": _get_label(element(root, "data/work")),
        "form_of_work": decorated_list_item(root, _xp(rt, "formOfWork")),
        "main_title": titles(root, _xp(rt, "title")),
        "variant_titles": titles(root, _xp(rt, "variantTitle")),
        "origin_date": first(dates(root, _xp(rt, "originDate"), "start", "end")),
        "display_date": text(root, ".//displayDate"),
        "origin_places": origin_places(root, _xp(rt, "originPlace")),
        "date_other": dates(root, _xp(rt,"dateOther"), "start", "end"),
        "incipit": decorated_text(root, _xp(rt, "incipit")),
        "literature": decorated_text(root, _xp(rt, "listBibl")),
        "note": decorated_text(root, _xp(rt, "note")),
        "agents": agents(root, _xp(rt, "agent")),
        "longitude": text(root, _xp(rt, "point/longitude")),
        "latitude": text(root, _xp(rt, "point/latitude")),
        "electronic_locators": electronic_locators(root, _xp(rt, "electronicLocator")),
    })

    return clean_empty(data)