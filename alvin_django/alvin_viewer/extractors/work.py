from lxml import etree
from .common import origin_places, electronic_locators, agents, get_dates, get_date_other

def _titles(root: etree._Element, xp: str):
    return [{
        "main_title": t.findtext("./mainTitle"),
        "subtitle": t.findtext("./subtitle"),
        "orientation_code": t.findtext("./orientationCode"),
        "type": t.get("variantType"),
    } for t in root.xpath(xp)]

def extract(root: etree._Element) -> dict:
    return {
        "form_of_work": root.findtext(".//formOfWork"),
        "main_title": _titles(root, "//work/title"),
        "variant_titles": _titles(root, "//variantTitle"),
        "start_date": get_dates("start", root),
        "end_date": get_dates("end", root),
        "origin_places": origin_places(root),
        "display_date": root.findtext(".//displayDate"),
        "date_other": get_date_other(root),
        "incipit": root.findtext(".//incipit"),
        "literature": root.findtext(".//work/listBibl"),
        "note": root.findtext(".//work/note"),
        "agents": agents(root, ".//data/work/agent"),
        "longitude": root.findtext(".//point/longitude"),
        "latitude": root.findtext(".//point/latitude"),
        "electronic_locators": electronic_locators(root),
    }