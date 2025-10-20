from lxml import etree
from django.utils import translation
from ..xmlutils.nodes import text, texts, attr, element, elements, first
from .common import _get_label, _get_value, _xp, decorated_list, components, decorated_location, decorated_agents, decorated_subject_authority, decorated_text, decorated_texts, decorated_texts_with_type, dates, electronic_locators, related_records, origin_places, _titles
from .cleaner import clean_empty

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
        "type_of_resource": decorated_list(root, "typeOfResource"),
        "collection": decorated_list(root, "collection"),
        "production_method": decorated_list(root, "productionMethod"),
        "main_title": _titles(root, _xp("title")),
        "variant_titles": _titles(root, _xp("variantTitle")),
        "location": decorated_location(root, "physicalLocation/heldBy/location"),
        "sublocation": decorated_text(root, "physicalLocation/sublocation"),
        "shelf_mark": decorated_text(root, "physicalLocation/shelfMark"),
        "former_shelf_mark": decorated_texts(root, "physicalLocation/formerShelfMark"),
        "subcollection": decorated_list(root, _xp("physicalLocation/subcollection/*")),
        "physcial_location_note": decorated_text(root, "physicalLocation/note[@noteType='general']"),
        "agents": decorated_agents(root, "agent"),
        "languages": decorated_list(root, _xp("language")),
        "description_languages": decorated_list(root, _xp("adminMetadata/descriptionLanguage")),
        "edition_statement": decorated_text(root, "editionStatement"),
        "origin_places": origin_places(root),
        "publications": decorated_texts(root, "publication"),
        "origin_date": first(dates(root, "record", "originDate", "start", "end")),
        "display_date": decorated_text(root, "originDate/displayDate"),
        "date_other": dates(root, "record", "dateOther", "start", "end"),
        "extent": decorated_text(root, "extent"),
        "dimensions": _dimensions(root),
        "measure": _measure(root, "measure"),
        "physical_description_notes": decorated_texts_with_type(root, "physicalDescription", "note", "./@noteType"),
        "base_material": decorated_list(root, _xp("baseMaterial")),
        "applied_material": decorated_list(root, _xp("appliedMaterial")),
        "summary": decorated_text(root, "summary"),
        "transcription": decorated_text(root, "transcription"),
        "table_of_contents": decorated_text(root, "tableOfContents"),
        "literature": decorated_text(root, "listBibl"),
        "notes": decorated_texts_with_type(root, "note", ".", "./@noteType"),
        "related_records": related_records(root, "relatedTo"),
        "electronic_locators": electronic_locators(root),
        "genre_form": decorated_list(root, _xp("genreForm")),
        "subjects": _subjects_misc(root),
        "subject_person": decorated_subject_authority(root, "person"),
        "subject_organisation": decorated_subject_authority(root, "organisation"),
        "subject_place": decorated_subject_authority(root, "place"),
        "classifications": _classifications(root),
        "access_policy": decorated_text(root, "accessPolicy"),
        "binding_description": {
            "binding": root.findtext("data/record/bindingDesc/binding"),
            "deco_note": root.findtext("data/record/bindingDesc/decoNote")
        },
        "deco_note": decorated_text(root, "decoNote"),
        "identifiers": _identifiers(root),
        "work": root.findall("data/record/work"),
        "files": root.find("data/fileSection"),
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

def _ms_contents(root: etree._Element) -> dict:
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