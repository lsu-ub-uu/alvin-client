from typing import Callable, Iterable, Optional, Any, Dict, List
from lxml import etree
from django.utils import translation

from ..xmlutils.nodes import text, texts, attr, element, elements, first
from .common import _get_label, _get_value, _get_attribute_item, _xp, decorated_list, decorated_list_item, decorated_list_item_with_text, components, decorated_location, decorated_agents, decorated_subject_authority, decorated_text, decorated_texts, decorated_texts_with_type, dates, electronic_locators, related_records, related_works, origin_places, _titles
from .cleaner import clean_empty

XP = {
    "identifiers": etree.XPath("//record/identifier"),
    "classifications": etree.XPath("//record/classification"),
    "dimensions": etree.XPath(".//dimensions"),

}

def _identifiers(root: etree._Element):
    return [{"type": id.get("type"), "identifier": id.findtext(".")} for id in root.xpath("//record/identifier")]

def _subjects_misc(root: etree._Element):
    return [{
        "type": attr(s, "./@authority").replace("_", " ") if attr(s, "./@authority") is not None else None,
        "topic": text(s, ".//topic"),
        "genreForm": text(s, ".//genreForm"),
        "geographicCoverage": text(s, ".//geographicCoverage"),
        "temporal": text(s, ".//temporal"),
        "occupation": text(s, ".//occupation"),
    } for s in elements(root, _xp("subject[not(@type = 'person' or @type = 'organisation' or @type = 'place')]"))]

def _classifications(root: etree._Element):
    return [{"type": c.get("authority"), "classification": c.findtext(".")} for c in root.xpath("//record/classification")]

def _dimensions(root: etree._Element):
    return [{
        "label": _get_label(e),
        "scope": _get_value(element(e, "scope")),
        "height": decorated_text(e, _xp("height", absolute=True)),
        "width": decorated_text(e, _xp("width", absolute=True)),
        "depth": decorated_text(e, _xp("depth", absolute=True)),
        "diameter": decorated_text(e, _xp("diameter", absolute=True)),
        "unit": _get_value(element(e, "unit")),
    } for e in elements(root, _xp(f"dimensions"))]

def _measure(root: etree._Element, xp: str):

    e = element(root, _xp(xp))
    if e is None:
        return None

    measure = {
        "label": _get_label(e),
        "weight": text(e, "weight"),
        "unit": _get_value(element(e, "unit"))
    }

    return measure or None

def extract(root: etree._Element) -> dict:
    data = {
        "type_of_resource": decorated_list_item(root, _xp("typeOfResource")),
        "collection": decorated_list_item(root, _xp("collection")),
        "production_method": decorated_list_item(root, _xp("productionMethod")),
        "main_title": _titles(root, _xp("title")),
        "variant_titles": _titles(root, _xp("variantTitle")),
        "location": decorated_location(root, "physicalLocation/heldBy/location"),
        "sublocation": decorated_text(root, "physicalLocation/sublocation"),
        "shelf_mark": decorated_text(root, "physicalLocation/shelfMark"),
        "former_shelf_mark": decorated_texts(root, _xp("physicalLocation/formerShelfMark")),
        "subcollection": decorated_list(root, _xp("physicalLocation/subcollection/*")),
        "physcial_location_note": decorated_text(root, "physicalLocation/note[@noteType='general']"),
        "agents": decorated_agents(root, _xp("agent")),
        "languages": decorated_list(root, _xp("language")),
        "description_languages": decorated_list(root, _xp("adminMetadata/descriptionLanguage")),
        "edition_statement": decorated_text(root, "editionStatement"),
        "origin_places": origin_places(root, _xp("originPlace")),
        "publications": decorated_texts(root, _xp("publication")),
        "origin_date": first(dates(root, _xp("originDate"), "start", "end")),
        "display_date": decorated_text(root, "originDate/displayDate"),
        "date_other": dates(root, _xp("dateOther"), "start", "end"),
        "extent": decorated_text(root, "extent"),
        "dimensions": _dimensions(root),
        "measure": _measure(root, "measure"),
        "physical_description_notes": decorated_texts_with_type(root, _xp("physicalDescription"), "note", "./@noteType"),
        "base_material": decorated_list(root, _xp("baseMaterial")),
        "applied_material": decorated_list(root, _xp("appliedMaterial")),
        "summary": decorated_text(root, "summary"),
        "transcription": decorated_text(root, "transcription"),
        "table_of_contents": decorated_text(root, "tableOfContents"),
        "literature": decorated_text(root, "listBibl"),
        "notes": decorated_texts_with_type(root, _xp("note"), ".", "./@noteType"),
        "related_records": related_records(root, _xp("relatedTo"), "record"),
        "electronic_locators": electronic_locators(root, _xp("electronicLocator")),
        "genre_form": decorated_list(root, _xp("genreForm")),
        "subjects": _subjects_misc(root),
        "subject_person": decorated_subject_authority(root, "person"),
        "subject_organisation": decorated_subject_authority(root, "organisation"),
        "subject_place": decorated_subject_authority(root, "place"),
        "classifications": _classifications(root),
        "access_policy": decorated_text(root, _xp("accessPolicy")),
        "binding_description": {
            "binding": root.findtext("data/record/bindingDesc/binding"),
            "deco_note": root.findtext("data/record/bindingDesc/decoNote")
        },
        "deco_note": decorated_text(root, _xp("decoNote")),
        "identifiers": _identifiers(root),
        "work": related_works(root, _xp("work")),
        "files": root.find("data/fileSection"),
    }

    if data["type_of_resource"]["code"] == 'col':
        data.update(_col(root))
    if element(root, _xp("productionMethod")) is not None and element(root, _xp("productionMethod")).text == 'manuscript':
        data.update(_ms(root))
    if data["type_of_resource"]["code"] == 'not':
        data.update(_not(root))
    if data["type_of_resource"]["code"] == 'car':
        data.update(_car(root))
    if element(root, _xp("recordInfo/validationType/linkedRecordId")).text == 'recordArtifactNumismatic':
        data.update(_coins(root))

    return clean_empty(data)


def _col(root: etree._Element) -> dict:
    return {
    "level": decorated_list_item(root, _xp("level")),
    "shelf_metres": decorated_text(root, _xp("extent[@unit='shelfMetres']")),
    "archival_units": decorated_text(root, _xp("extent[@unit='archivalUnits']")),
    "other_findaid": decorated_texts(root, _xp("otherfindaid")),
    "weeding": decorated_texts(root, _xp("weeding")),
    "related_material": decorated_texts(root, _xp("relatedmaterial")),
    "arrangement": decorated_texts(root, _xp("arrangement")),
    "accruals": decorated_texts(root, _xp("accruals")),
    "components": components(elements(root, "//descriptionOfSubordinateComponents/component01"))
    }

def _ms(root: etree._Element) -> dict:
    return {
    "locus": decorated_text(root, _xp("locus")),
    "incipit": decorated_text(root, _xp("incipit")),
    "explicit": decorated_text(root, _xp("explicit")),
    "rubric": decorated_text(root, _xp("rubric")),
    "final_rubric": decorated_text(root, _xp("finalRubric")),
    "components": components(elements(root, "//msContents/msItem01"))
    }

def _not(root: etree._Element) -> dict:
    return {
    "music_key": decorated_list(root, _xp("musicKey")),
    "music_key_other": decorated_text(root, _xp("musicKeyOther")),
    "music_medium": decorated_list(root, _xp("musicMedium")),
    "music_medium_other": decorated_text(root, _xp("musicMediumOther")),
    "music_notation": decorated_list(root, _xp("musicNotation")),
    }

def _car(root: etree._Element) -> dict:
    return {
        "scale": decorated_text(root, _xp("cartographicAttributes/scale")),
        "projection": decorated_text(root, _xp("cartographicAttributes/projection")),
        "coordinates": decorated_text(root, _xp("cartographicAttributes/coordinates"))
    }

def _coins(root: etree._Element) -> dict:
    return {
        "appraisal": {
            "label": _get_label(element(root, _xp("appraisal"))),
            "value": text(root, _xp("appraisal/value")),
            "currency": text(root, _xp("appraisal/currency")),
        },
        "axis": {
            "label": _get_label(element(root, _xp("axis"))),
            "item": decorated_list_item(root, _xp("axis/clock")),
        },
        "edge": decorated_list_item_with_text(root, _xp("edge"), "description", "legend"),
        "conservation_state": decorated_list(root, _xp("conservationState")),
        "obverse": {
            "label": _get_label(element(root, _xp("obverse"))),
            "description": decorated_text(root, _xp("obverse/description")),
            "legend": decorated_text(root, _xp("obverse/legend")),
        },
        "reverse": {
            "label": _get_label(element(root, _xp("reverse"))),
            "description": decorated_text(root, _xp("reverse/description")),
            "legend": decorated_text(root, _xp("reverse/legend")),
        },
        "countermark": decorated_texts(root, _xp("countermark")),
    }