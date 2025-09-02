from lxml import etree
from .common import authority_names, variant_names_list, electronic_locators, get_dates, get_date_other

AUTH_NAME = {
    "geographic": "./geographic",
    "orientation_code": "./orientationCode",
}

VARIANT = {
    "language": "./@lang",
    "geographic": "./geographic",
    "orientation_code": "./orientationCode",
}

def extract(root: etree._Element) -> dict:
    return {
        "authority_names": authority_names(root, AUTH_NAME),
        "variant_names": variant_names_list(root, VARIANT),
        "country": root.findtext(".//country"),
        "latitude": root.findtext(".//point/latitude"),
        "longitude": root.findtext(".//point/longitude"),
        "electronic_locators": electronic_locators(root),
    }