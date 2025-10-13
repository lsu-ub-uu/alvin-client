from lxml import etree
from .common import origin_places, electronic_locators, get_dates, get_date_other
from ..xmlutils.nodes import text, attr, elements
from ..xmlutils.decorated import decorated_text, decorated_agents

def _titles(root: etree._Element, xp: str):
    return [{
        "main_title": text(t, "mainTitle"),
        "subtitle": text(t, "subtitle"),
        "orientation_code": text(t, "orientationCode"),
        "type": attr(t, "./@variantType"),
    } for t in elements(root, xp)]

def extract(root: etree._Element) -> dict:
    return {
        "form_of_work": text(root, ".//formOfWork"),
        "main_title": _titles(root, "//work/title"),
        "variant_titles": _titles(root, "//variantTitle"),
        "start_date": get_dates("start", root),
        "end_date": get_dates("end", root),
        "origin_places": origin_places(root),
        "display_date": text(root, ".//displayDate"),
        "date_other": get_date_other(root),
        "incipit": text(root, ".//incipit"),
        "literature": text(root, ".//work/listBibl"),
        "note": text(root, ".//work/note"),
        "agents": decorated_agents(root, "agent"),
        "longitude": text(root, ".//point/longitude"),
        "latitude": text(root, ".//point/latitude"),
        "electronic_locators": electronic_locators(root),
    }