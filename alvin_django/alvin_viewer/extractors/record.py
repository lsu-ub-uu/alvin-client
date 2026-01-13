from typing import Callable, Iterable, Optional, Any, Dict, List
from lxml import etree
from django.utils import translation

from ..xmlutils.nodes import text, attr, element, elements, first
from .common import (_get_label, _get_value, _norm_rt, _xp, _get_attribute_item)
from .common import *
from .cleaner import clean_empty
from .records import AlvinRecord
from .metadata import Classification, Dimension, Measure, SubjectMiscEntry

rt = _norm_rt("alvin-record")

def _col(root: etree._Element) -> dict:
    return compact({
    "level": decorated_list_item(root, _xp(rt, "level")),
    "shelf_metres": decorated_text(root, _xp(rt, "extent[@unit='shelfMetres']")),
    "archival_units": decorated_text(root, _xp(rt, "extent[@unit='archivalUnits']")),
    "other_findaid": decorated_texts(root, _xp(rt, "otherfindaid")),
    "weeding": decorated_texts(root, _xp(rt, "weeding")),
    "related_material": decorated_texts(root, _xp(rt, "relatedmaterial")),
    "arrangement": decorated_texts(root, _xp(rt, "arrangement")),
    "accruals": decorated_texts(root, _xp(rt, "accruals")),
    "components": components(elements(root, "//descriptionOfSubordinateComponents/component01"))
    })

def _ms(root: etree._Element) -> dict:
    return compact({
    "locus": decorated_text(root, _xp(rt, "locus")),
    "incipit": decorated_text(root, _xp(rt, "incipit")),
    "explicit": decorated_text(root, _xp(rt, "explicit")),
    "rubric": decorated_text(root, _xp(rt, "rubric")),
    "final_rubric": decorated_text(root, _xp(rt, "finalRubric")),
    "components": components(elements(root, "//msContents/msItem01"))
    })

def _not(root: etree._Element, rt) -> dict:
    return compact({
    "music_key": decorated_list(root, _xp(rt, "musicKey")),
    "music_key_other": decorated_text(root, _xp(rt, "musicKeyOther")),
    "music_medium": decorated_list(root, _xp(rt, "musicMedium")),
    "music_medium_other": decorated_text(root, _xp(rt, "musicMediumOther")),
    "music_notation": decorated_list(root, _xp(rt, "musicNotation")),
    })

def _car(root: etree._Element, rt) -> dict:
    return compact({
        "scale": decorated_text(root, _xp(rt, "cartographicAttributes/scale")),
        "projection": decorated_text(root, _xp(rt, "cartographicAttributes/projection")),
        "coordinates": decorated_text(root, _xp(rt, "cartographicAttributes/coordinates"))
    })

def _coins(root: etree._Element) -> dict:
    return compact({
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
    })

def _subjects_misc(root: etree._Element, xp: str):
    
    targets = elements(root, xp)
    if targets is None:
        return None

    subjects = [SubjectMiscEntry(
            label = _get_attribute_item(attr(e, "./@authority")),
            topic = text(e, "topic"),
            genre_form = text(e, "genreForm"),
            geographic_coverage = text(e, "geographicCoverage"),
            temporal = text(e, "temporal"),
            occupation = text(e, "occupation"),
    ) for e in targets]

    if all(s.is_empty() for s in subjects):
        return None
    return subjects

def _classifications(root: etree._Element, xp):
    targets = elements(root, xp)
    if not targets:
        return None
    
    cs = [Classification(
        label = _get_label(t),
        type = _get_attribute_item(attr(t, "./@authority")),
        text = text(t, "."),
        ) for t in targets]
    
    if all(c.is_empty() for c in cs):
        return None
    return cs


def _dimensions(root: etree._Element, xp: str) -> List[Dict]:
    targets = elements(root, xp)
    if not targets:
        return None
    
    ds = [Dimension(
        label =_get_label(t),
        scope = _get_value(element(t, "scope")),
        height = decorated_text(t, _xp(rt, "height", absolute=True)),
        width = decorated_text(t, _xp(rt, "width", absolute=True)),
        depth = decorated_text(t, _xp(rt, "depth", absolute=True)),
        diameter = decorated_text(t, _xp(rt, "diameter", absolute=True)),
        unit = _get_value(element(t, "unit")),
        ) for t in targets]
    
    if all(d.is_empty() for d in ds):
        return None
    return ds

def _measure(root: etree._Element, xp: str):
    target = element(root, xp)
    if target is None:
        return None
    
    m = Measure(
        label = _get_label(target),
        weight = text(target, "weight"),
        unit = _get_value(element(target, "unit"))
    )

    if m.is_empty():
        return None
    return m

def extract(root: etree._Element) -> AlvinRecord:
    
    return AlvinRecord(
        id = text(root, _xp(rt, "recordInfo/id")),
        record_type = "alvin-record",
        type_of_resource = decorated_list_item(root, _xp(rt, "typeOfResource")),
        collection = decorated_list_item(root, _xp(rt, "collection")),
        production_method = decorated_list_item(root, _xp(rt, "productionMethod")),
        main_title = titles(root, _xp(rt, "title")),
        variant_titles = titles(root, _xp(rt, "variantTitle")),
        agents = agents(root, _xp(rt, "agent")),
        location = location(root, "physicalLocation/heldBy/location"),
        sublocation = decorated_text(root, _xp(rt, "physicalLocation/sublocation")),
        shelf_mark = decorated_text(root, _xp(rt, "physicalLocation/shelfMark")),
        former_shelf_mark = decorated_texts(root, _xp(rt, "physicalLocation/formerShelfMark")),
        subcollection = decorated_list(root, _xp(rt, "physicalLocation/subcollection/*")),
        physical_location_note = decorated_text(root, _xp(rt, "physicalLocation/note[@noteType='general']"), _xp(rt, "physicalLocation")),
        languages = decorated_list(root, _xp(rt, "language")),
        edition_statement = decorated_text(root, "editionStatement"),
        origin_places = origin_places(root, _xp(rt, "originPlace")),
        publications = decorated_texts(root, _xp(rt, "publication")),
        origin_date = dates(root, _xp(rt, "originDate"), "start", "end"),
        date_other = [dates(date, ".", "start", "end") for date in elements(root, _xp(rt, "dateOther"))],
        extent = decorated_text(root, _xp(rt, "extent")),
        dimensions = _dimensions(root, _xp(rt, "dimensions")),
        measure = _measure(root, _xp(rt, "measure")),
        base_material = decorated_list(root, _xp(rt, "baseMaterial")),
        applied_material = decorated_list(root, _xp(rt, "appliedMaterial")),
        physical_description_notes = decorated_texts_with_type(root, _xp(rt, "physicalDescription"), "note", "./@noteType"),
        summary = decorated_text(root, _xp(rt, "summary")),
        transcription = decorated_text(root, "transcription"),
        table_of_contents = decorated_text(root, "tableOfContents"),
        literature = decorated_text(root, _xp(rt, "listBibl")),
        notes = decorated_texts_with_type(root, _xp(rt, "note"), ".", "./@noteType"),
        access_policy = decorated_text(root, _xp(rt, "accessPolicy")),
        related_records = related_records(root, _xp(rt, "relatedTo")),
        electronic_locators = electronic_locators(root, _xp(rt, "electronicLocator")),
        genre_form = decorated_list(root, _xp(rt, "genreForm")),
        subjects = _subjects_misc(root, _xp(rt, "subject[not(@type = 'person' or @type = 'organisation' or @type = 'place')]")),
        subject_person = subject_authority(root, rt, "person"),
        subject_organisation = subject_authority(root, rt, "organisation"),
        subject_place = subject_authority(root, rt, "place"),
        classifications = _classifications(root, _xp(rt, "classification")),
        deco_note = decorated_text(root, _xp(rt, "decoNote")),
        binding = decorated_text(root, _xp(rt, "bindingDesc/binding"), _xp(rt, "bindingDesc")),
        binding_deco_note = decorated_text(root, _xp(rt, "bindingDesc/decoNote"), _xp(rt, "bindingDesc")),
        identifiers = identifiers(root, _xp(rt, "identifier")),
        #work = related_works(root, _xp(rt, "work")),
        files = element(root, _xp(rt, "fileSection")),
    )

    if data["type_of_resource"]["code"] == 'col':
        data.update(_col(root))
    if element(root, _xp(rt, "productionMethod")) is not None and element(root, _xp(rt, "productionMethod")).text == 'manuscript':
        data.update(_ms(root))
    if data["type_of_resource"]["code"] == 'not':
        data.update(_not(root, rt))
    if data["type_of_resource"]["code"] == 'car':
        data.update(_car(root, rt))
    if element(root, _xp(rt, "recordInfo/validationType/linkedRecordId")).text == 'recordArtifactNumismatic':
        data.update(_coins(root))

    return clean_empty(data)