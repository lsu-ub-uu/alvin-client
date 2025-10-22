from lxml import etree
from .common import _titles, origin_places, electronic_locators, dates
from ..xmlutils.nodes import text, attr, elements
from .common import decorated_text, decorated_agents

def extract(root: etree._Element) -> dict:
    return {
        "form_of_work": text(root, ".//formOfWork"),
        "main_title": _titles(root, "//work/title"),
        "variant_titles": _titles(root, "//variantTitle"),
        #"start_date": get_dates(root, "originDate", "start"),
        #"end_date": get_dates(root, "originDate", "end"),
        "origin_places": origin_places(root, "data/work/originPlace"),
        "display_date": text(root, ".//displayDate"),
        "date_other": dates(root, "data/work/dateOther", "start", "end"),
        "incipit": text(root, ".//incipit"),
        "literature": text(root, ".//work/listBibl"),
        "note": text(root, ".//work/note"),
        "agents": decorated_agents(root, "agent"),
        "longitude": text(root, ".//point/longitude"),
        "latitude": text(root, ".//point/latitude"),
        "electronic_locators": electronic_locators(root, "electronicLocator"),
    }