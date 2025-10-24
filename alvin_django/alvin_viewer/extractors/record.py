from typing import Callable, Iterable, Optional, Any, Dict, List
from lxml import etree
from django.utils import translation

from ..xmlutils.nodes import text, texts, attr, element, elements, first
from .common import (_get_label, _get_value, decorated_list, decorated_list_item, decorated_list_item_with_text,
                    decorated_text, decorated_texts, decorated_texts_with_type,_xp, _norm_rt, _common, agents, components, 
                    dates, electronic_locators, location, origin_places, related_records, related_works,
                    _subject_authority, _titles)
from .cleaner import clean_empty

XP = {
    "identifiers": etree.XPath("//record/identifier"),
    "classifications": etree.XPath("//record/classification"),
    "dimensions": etree.XPath(".//dimensions"),
}

def extract(root: etree._Element) -> dict:
    rt = _norm_rt("alvin-record")
    
    def _col(root: etree._Element) -> dict:
        return {
        "level": decorated_list_item(root, _xp(rt, "level")),
        "shelf_metres": decorated_text(root, _xp(rt, "extent[@unit='shelfMetres']")),
        "archival_units": decorated_text(root, _xp(rt, "extent[@unit='archivalUnits']")),
        "other_findaid": decorated_texts(root, _xp(rt, "otherfindaid")),
        "weeding": decorated_texts(root, _xp(rt, "weeding")),
        "related_material": decorated_texts(root, _xp(rt, "relatedmaterial")),
        "arrangement": decorated_texts(root, _xp(rt, "arrangement")),
        "accruals": decorated_texts(root, _xp(rt, "accruals")),
        "components": components(elements(root, "//descriptionOfSubordinateComponents/component01"))
        }

    def _ms(root: etree._Element) -> dict:
        return {
        "locus": decorated_text(root, _xp(rt, "locus")),
        "incipit": decorated_text(root, _xp(rt, "incipit")),
        "explicit": decorated_text(root, _xp(rt, "explicit")),
        "rubric": decorated_text(root, _xp(rt, "rubric")),
        "final_rubric": decorated_text(root, _xp(rt, "finalRubric")),
        "components": components(elements(root, "//msContents/msItem01"))
        }

    def _not(root: etree._Element) -> dict:
        return {
        "music_key": decorated_list(root, _xp(rt, "musicKey")),
        "music_key_other": decorated_text(root, _xp(rt, "musicKeyOther")),
        "music_medium": decorated_list(root, _xp(rt, "musicMedium")),
        "music_medium_other": decorated_text(root, _xp(rt, "musicMediumOther")),
        "music_notation": decorated_list(root, _xp(rt, "musicNotation")),
        }

    def _car(root: etree._Element) -> dict:
        return {
            "scale": decorated_text(root, _xp(rt, "cartographicAttributes/scale")),
            "projection": decorated_text(root, _xp(rt, "cartographicAttributes/projection")),
            "coordinates": decorated_text(root, _xp(rt, "cartographicAttributes/coordinates"))
        }
    
    def _coins(root: etree._Element) -> dict:
        return {
            "appraisal": {
                "label": _get_label(element(root, _xp(rt, "appraisal"))),
                "value": text(root, _xp(rt, "appraisal/value")),
                "currency": text(root, _xp(rt, "appraisal/currency")),
            },
            "axis": {
                "label": _get_label(element(root, _xp(rt, "axis"))),
                "item": decorated_list_item(root, _xp(rt, "axis/clock")),
            },
            "edge": decorated_list_item_with_text(root, _xp(rt, "edge"), "description", "legend"),
            "conservation_state": decorated_list(root, _xp(rt, "conservationState")),
            "obverse": {
                "label": _get_label(element(root, _xp(rt, "obverse"))),
                "description": decorated_text(root, _xp(rt, "obverse/description")),
                "legend": decorated_text(root, _xp(rt, "obverse/legend")),
            },
            "reverse": {
                "label": _get_label(element(root, _xp(rt, "reverse"))),
                "description": decorated_text(root, _xp(rt, "reverse/description")),
                "legend": decorated_text(root, _xp(rt, "reverse/legend")),
            },
            "countermark": decorated_texts(root, _xp(rt, "countermark")),
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
        } for s in elements(root, _xp(rt, "subject[not(@type = 'person' or @type = 'organisation' or @type = 'place')]"))]

    def _classifications(root: etree._Element):
        return [{"type": c.get("authority"), "classification": c.findtext(".")} for c in root.xpath("//record/classification")]

    def _dimensions(root: etree._Element):
        return [{
            "label": _get_label(e),
            "scope": _get_value(element(e, "scope")),
            "height": decorated_text(e, _xp(rt, "height", absolute=True)),
            "width": decorated_text(e, _xp(rt, "width", absolute=True)),
            "depth": decorated_text(e, _xp(rt, "depth", absolute=True)),
            "diameter": decorated_text(e, _xp(rt, "diameter", absolute=True)),
            "unit": _get_value(element(e, "unit")),
        } for e in elements(root, _xp(rt, "dimensions"))]

    def _measure(root: etree._Element, xp: str):

        e = element(root, _xp(rt, xp))
        if e is None:
            return None

        measure = {
            "label": _get_label(e),
            "weight": text(e, "weight"),
            "unit": _get_value(element(e, "unit"))
        }

        return measure or None
    
    data = {
        "type_of_resource": decorated_list_item(root, _xp(rt, "typeOfResource")),
        "collection": decorated_list_item(root, _xp(rt, "collection")),
        "production_method": decorated_list_item(root, _xp(rt, "productionMethod")),
        "main_title": _titles(root, _xp(rt, "title")),
        "variant_titles": _titles(root, _xp(rt, "variantTitle")),
        "location": location(root, rt, "physicalLocation/heldBy/location"),
        "sublocation": decorated_text(root, "physicalLocation/sublocation"),
        "shelf_mark": decorated_text(root, "physicalLocation/shelfMark"),
        "former_shelf_mark": decorated_texts(root, _xp(rt, "physicalLocation/formerShelfMark")),
        "subcollection": decorated_list(root, _xp(rt, "physicalLocation/subcollection/*")),
        "physcial_location_note": decorated_text(root, "physicalLocation/note[@noteType='general']"),
        "agents": agents(root, _xp(rt, "agent")),
        "languages": decorated_list(root, _xp(rt, "language")),
        "description_languages": decorated_list(root, _xp(rt, "adminMetadata/descriptionLanguage")),
        "edition_statement": decorated_text(root, "editionStatement"),
        "origin_places": origin_places(root, _xp(rt, "originPlace")),
        "publications": decorated_texts(root, _xp(rt, "publication")),
        "origin_date": first(dates(root, _xp(rt, "originDate"), "start", "end")),
        "display_date": decorated_text(root, "originDate/displayDate"),
        "date_other": dates(root, _xp(rt, "dateOther"), "start", "end"),
        "extent": decorated_text(root, "extent"),
        "dimensions": _dimensions(root),
        "measure": _measure(root, "measure"),
        "physical_description_notes": decorated_texts_with_type(root, _xp(rt, "physicalDescription"), "note", "./@noteType"),
        "base_material": decorated_list(root, _xp(rt, "baseMaterial")),
        "applied_material": decorated_list(root, _xp(rt, "appliedMaterial")),
        "summary": decorated_text(root, "summary"),
        "transcription": decorated_text(root, "transcription"),
        "table_of_contents": decorated_text(root, "tableOfContents"),
        "literature": decorated_text(root, "listBibl"),
        "notes": decorated_texts_with_type(root, _xp(rt, "note"), ".", "./@noteType"),
        "related_records": related_records(root, _xp(rt, "relatedTo"), "record"),
        "electronic_locators": electronic_locators(root, _xp(rt, "electronicLocator")),
        "genre_form": decorated_list(root, _xp(rt, "genreForm")),
        "subjects": _subjects_misc(root),
        "subject_person": _subject_authority(root, rt, "person"),
        "subject_organisation": _subject_authority(root, rt, "organisation"),
        "subject_place": _subject_authority(root, rt, "place"),
        "classifications": _classifications(root),
        "access_policy": decorated_text(root, _xp(rt, "accessPolicy")),
        "binding_description": {
            "binding": root.findtext("data/record/bindingDesc/binding"),
            "deco_note": root.findtext("data/record/bindingDesc/decoNote")
        },
        "deco_note": decorated_text(root, _xp(rt, "decoNote")),
        "identifiers": _identifiers(root),
        "work": related_works(root, _xp(rt, "work")),
        "files": root.find(_xp(rt, "fileSection")),
    }

    if data["type_of_resource"]["code"] == 'col':
        data.update(_col(root))
    if element(root, _xp(rt, "productionMethod")) is not None and element(root, _xp(rt, "productionMethod")).text == 'manuscript':
        data.update(_ms(root))
    if data["type_of_resource"]["code"] == 'not':
        data.update(_not(root))
    if data["type_of_resource"]["code"] == 'car':
        data.update(_car(root))
    if element(root, _xp(rt, "recordInfo/validationType/linkedRecordId")).text == 'recordArtifactNumismatic':
        data.update(_coins(root))

    return clean_empty(data)