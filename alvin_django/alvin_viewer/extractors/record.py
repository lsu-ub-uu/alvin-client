from lxml import etree
from .common import origin_places, electronic_locators, related_records, components, get_dates, get_date_other
from django.utils import translation
from ..xmlutils.nodes import text, texts, attr, elements, first
from ..xmlutils.decorated import decorated_list, decorated_text, decorated_texts, decorated_texts_with_type, decorated_agents
from .cleaner import clean_empty

BASE_XP = "data/record/"

def _titles(root: etree._Element, xp: str):
    titles = [{
        "type": attr(e, "./@variantType"),
        "main_title": text(e, "./mainTitle"),
        "subtitle": text(e, "./subtitle"),
        "orientation_code": text(e, "./orientationCode"),
    } for e in elements(root, f"{BASE_XP}{xp}")]
    return titles or None

def _subject_authority(root: etree._Element, authority_type: str):
    md = decorated_agents(root, f"subject[@type = '{authority_type}']")
    return md

def _dimensions(root: etree._Element):
    return [{
        "scope": text(e, "./scope"),
        "height": text(e, "./height"),
        "width": text(e, "./width"),
        "depth": text(e, "./depth"),
        "diameter": text(e, "./diameter"),
        "unit": text(e, "./unit"),
    } for e in elements(root, f"{BASE_XP}dimensions")]

def _measure(root: etree._Element):
    return [{
        "weight": d.findtext("./weight"),
        "unit": d.findtext("./unit"),
    } for d in root.xpath("data/record/measure")]

def _notes(root: etree._Element):
    return [{"type": n.get("noteType"), "note": n.findtext(".")} for n in root.xpath("data/record/note")]

def _identifiers(root: etree._Element):
    return [{"type": id.get("type"), "identifier": id.findtext(".")} for id in root.xpath("//record/identifier")]

def _subjects_misc(root: etree._Element):
    return [{
        "type": s.get("authority"),
        "topic": s.findtext(".//topic"),
        "genreForm": s.findtext(".//genreForm"),
        "geographicCoverage": s.findtext(".//geographicCoverage"),
        "temporal": s.findtext(".//temporal"),
        "occupation": s.findtext(".//occupation"),
    } for s in elements(root, "data/record/subject[not(@type = 'person' or @type = 'organisation' or @type = 'place')]")]

def _classifications(root: etree._Element):
    return [{"type": c.get("authority"), "classification": c.findtext(".")} for c in root.xpath("//record/classification")]

def extract(root: etree._Element) -> dict:
    data = {
        "type_of_resource": decorated_list(root, "typeOfResource"),
        "collection": decorated_list(root, "collection"),
        "production_method": decorated_list(root, "productionMethod"),
        "main_title": _titles(root, "title"),
        "variant_titles": _titles(root, "variantTitle"),
        "physical_location": {
            "held_by": first(decorated_agents(root, "physicalLocation/heldBy/location")),
            "sublocation": decorated_text(root, "physicalLocation/sublocation"),
            "shelf_mark": decorated_text(root, "physicalLocation/shelfMark"),
            "former_shelf_mark": decorated_texts(root, "physicalLocation/formerShelfMark"),
            "subcollection": decorated_list(root, "physicalLocation/subcollection/*"),
            "note": decorated_text(root, "physicalLocation/note[@noteType='general']"),
        },
        "agents": decorated_agents(root, "agent"),
        "languages": decorated_list(root, "language"),
        "description_languages": decorated_list(root, "adminMetadata/descriptionLanguage"),
        "edition_statement": decorated_text(root, "editionStatement"),
        "origin_places": origin_places(root),
        "publications": decorated_texts(root, "publication"),
        "start_date": get_dates("start", root.find("data/record/originDate")),
        "end_date": get_dates("end", root.find("data/record/originDate")),
        "display_date": decorated_text(root, "originDate/displayDate"),
        "date_other": get_date_other(root),
        "extent": decorated_text(root, "extent"),
        "dimensions": _dimensions(root),
        "measure": _measure(root),
        "physical_description_notes": decorated_texts_with_type(root, "physicalDescription", "note", "./@noteType"),
        "base_material": decorated_list(root, "baseMaterial"),
        "applied_material": decorated_list(root, "appliedMaterial"),
        "summary": decorated_text(root, "summary"),
        "transcription": decorated_text(root, "transcription"),
        "table_of_contents": decorated_text(root, "tableOfContents"),
        "literature": decorated_text(root, "listBibl"),
        "notes": decorated_texts_with_type(root, "note", ".", "./@noteType"),
        "related_records": related_records(root, "data/record/relatedTo"),
        "electronic_locators": electronic_locators(root),
        "genre_form": decorated_list(root, "genreForm"),
        "subjects": _subjects_misc(root),
        "subject_person": _subject_authority(root, "person"),
        "subject_organisation": _subject_authority(root, "organisation"),
        "subject_place": _subject_authority(root, "place"),
        "classifications": _classifications(root),
        "access_policy": decorated_text(root, "accessPolicy"),
        "binding_description": {
            "binding": root.findtext("data/record/bindingDesc/binding"),
            "deco_note": root.findtext("data/record/bindingDesc/decoNote")
        },
        "deco_note": decorated_text(root, "decoNote"),
        "identifiers": _identifiers(root),
        "work": root.findall("data/record/work"),
        "files": root.find(".//file"),
        # ...
        "components": components(elements(root, "//descriptionOfSubordinateComponents/component01"))
    }

    return clean_empty(data)


def _col(root: etree._Element) -> dict:
    return {
    "level": decorated_texts(root, "level"),
    "shelf_metres": decorated_text(root, "extent[@unit='shelfMetres']"),
    "archival_units": decorated_text(root, "extent[@unit='archivalUnits']"),
    "other_findaid": decorated_text(root, "otherfindaid"),
    "weeding": decorated_text(root, "weeding"),
    "related_material": decorated_text(root, "relatedmaterial"),
    "arrangement": decorated_text(root, "arrangement"),
    "accruals": decorated_text(root, "accruals"),
    }

def _ms(root: etree._Element) -> dict:
    return {
    "locus": decorated_text(root, "locus"),
    "incipit": decorated_text(root, "incipit"),
    "explicit": decorated_text(root, "explicit"),
    "rubric": decorated_text(root, "rubric"),
    "final_rubric": decorated_text(root, "finalRubric"),
    }

def _not(root: etree._Element) -> dict:
    return {
    "music_key": decorated_texts(root, "musicKey"),
    "music_key_other": decorated_text(root, "musicKey"),
    "music_medium": decorated_texts(root, "musicMedium"),
    "music_medium_other": decorated_text(root, "musicMediumOther"),
    "music_notation": decorated_texts(root, "musicNotation"),
    }