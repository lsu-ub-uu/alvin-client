from lxml import etree
from .common import authority_names, variant_names_list, electronic_locators, dates
from .mappings import place

def extract(root: etree._Element) -> dict:
    return {
        "authority_names": authority_names(root, place["AUTH_NAME"]),
        "variant_names": variant_names_list(root, place["VARIANT"]),
        "country": root.findtext(".//country"),
        "latitude": root.findtext(".//point/latitude"),
        "longitude": root.findtext(".//point/longitude"),
        "electronic_locators": electronic_locators(root),
    }