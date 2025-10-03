from lxml import etree
from .common import origin_places, electronic_locators, agents, related_records, components, get_dates, get_date_other
from django.utils import translation

def _titles(root: etree._Element, xp: str):
    titles = [{
        "type": t.get("variantType"),
        "main_title": t.findtext("./mainTitle"),
        "subtitle": t.findtext("./subtitle"),
        "orientation_code": t.findtext("./orientationCode"),
    } for t in root.xpath(xp)]
    return titles or None

def _subject_authority(root: etree._Element, type: str):
    return [{"id": a.findtext(".//linkedRecordId")} for a in root.xpath(f"//record/subject[@type = '{type}']")]

def _dimensions(root: etree._Element):
    return [{
        "scope": d.findtext("./scope"),
        "height": d.findtext("./height"),
        "width": d.findtext("./width"),
        "depth": d.findtext("./depth"),
        "diameter": d.findtext("./diameter"),
        "unit": d.findtext("./unit"),
    } for d in root.xpath(".//data/record/dimensions")]

def _measure(root: etree._Element):
    return [{
        "weight": d.findtext("./weight"),
        "unit": d.findtext("./unit"),
    } for d in root.xpath(".//data/record/measure")]

def _physical_description_notes(root: etree._Element):
    return [{"type": n.get("noteType"), "note": n.findtext(".")} for n in root.xpath("//physicalDescription/note")]

def _notes(root: etree._Element):
    return [{"type": n.get("noteType"), "note": n.findtext(".")} for n in root.xpath(".//data/record/note")]

def _identifiers(root: etree._Element):
    return [{"type": i.get("type"), "identifier": i.findtext(".")} for i in root.xpath("//record/identifier")]

def _subjects_misc(root: etree._Element):
    return [{
        "type": s.get("authority"),
        "topic": s.findtext(".//topic"),
        "genreForm": s.findtext(".//genreForm"),
        "geographicCoverage": s.findtext(".//geographicCoverage"),
        "temporal": s.findtext(".//temporal"),
        "occupation": s.findtext(".//occupation"),
    } for s in root.xpath("//record/subject[not(@type = 'person' or @type = 'organisation' or @type = 'place')]")]

def _classifications(root: etree._Element):
    return [{"type": c.get("authority"), "classification": c.findtext(".")} for c in root.xpath("//record/classification")]

def _get_value(element: etree._Element, lang: str | None = None) -> str:
    return element.get(f"_value_{lang}")

def _get_label(element: etree._Element, lang: str | None = None) -> str:
    if element is not None:
        return element.get(f"_{lang}")

def decorated_list(root: etree._Element, xp: str) -> dict:
    
    lang = translation.get_language()

    label = _get_label(root.find(f"data/record/{xp}"), lang)
    items = [_get_value(e, lang) for e in root.xpath(f"data/record/{xp}")]
    code = root.findtext(f"data/record/typeOfResource")
    
    return {
            "label": label,
            "items": items,
            "code": code,
            } or None

def extract(root: etree._Element) -> dict:
    return {
        "type_of_resource": decorated_list(root, "typeOfResource"),
        "collection": decorated_list(root, "collection"),
        "production_method": decorated_list(root, "productionMethod"),
        "main_title": _titles(root, "data/record/title"),
        "variant_titles": _titles(root, ".//data/record/variantTitle"),
        "physical_location": {
            "held_by": root.findtext(".//data/record/physicalLocation/heldBy/location/linkedRecordId"),
            "sublocation": root.findtext(".//data/record/physicalLocation/sublocation"),
            "shelf_mark": root.findtext(".//data/record/physicalLocation/shelfMark"),
            "former_shelf_mark": [s.findtext(".") for s in root.xpath(".//data/record/physicalLocation/formerShelfMark")],
            "subcollection": [sc.findtext(".") for sc in root.xpath(".//data/record/physicalLocation/subcollection/*")],
            "note": root.findtext(".//data/record/physicalLocation/note[@noteType='general']"),
        },
        "agents": agents(root, ".//data/record/agent"),
        "languages": decorated_list(root, "language"),
        "description_languages": decorated_list(root, "descriptionLanguage"),
        "edition_statement": root.findtext(".//record/editionStatement"),
        "origin_places": origin_places(root),
        "publications": [p.findtext(".") for p in root.xpath(".//data/record/publication")],
        "start_date": get_dates("start", root.find("./data/record/originDate")),
        "end_date": get_dates("end", root.find("./data/record/originDate")),
        "display_date": root.findtext(".//data/record/originDate/displayDate"),
        "date_other": get_date_other(root),
        "extent": root.findtext(".//record/extent"),
        "dimensions": _dimensions(root),
        "measure": _measure(root),
        "physical_description_notes": _physical_description_notes(root),
        "base_material": decorated_list(root, "baseMaterial"),
        "applied_material": decorated_list(root, "appliedMaterial"),
        "summary": root.findtext(".//data/record/summary"),
        "transcription": root.findtext(".//record/transcription"),
        "table_of_contents": root.findtext(".//record/tableOfContents"),
        "literature": root.findtext(".//record/listBibl"),
        "notes": _notes(root),
        "related_records": related_records(root, "./data/record/relatedTo"),
        "electronic_locators": electronic_locators(root),
        "genre_form": [g.findtext(".") for g in root.xpath("//data/record/genreForm")],
        "subjects": _subjects_misc(root),
        "subject_person": _subject_authority(root, "person"),
        "subject_organisation": _subject_authority(root, "organisation"),
        "subject_place": _subject_authority(root, "place"),
        "classifications": _classifications(root),
        "access_policy": root.findtext(".//record/accessPolicy"),
        "binding_description": {
            "binding": root.findtext(".//data/record/bindingDesc/binding"),
            "deco_note": root.findtext(".//data/record/bindingDesc/decoNote")
        },
        "deco_note": root.findtext(".//data/record/decoNote"),
        "identifiers": _identifiers(root),
        "work": root.findall(".//data/record/work"),
        "files": root.find(".//file"),
        # ...
        "components": components(root.xpath("//descriptionOfSubordinateComponents/component01")),
    }

def _col(root: etree._Element) -> dict:
    return {
    "level": [l.findtext(".") for l in root.xpath(".//data/record/level")],
    "shelf_metres": root.findtext(".//data/record/extent[@unit='shelfMetres']"),
    "archival_units": root.findtext(".//data/record/extent[@unit='archivalUnits']"),
    "other_findaid": root.findtext(".//data/record/otherfindaid"),
    "weeding": root.findtext(".//data/record/weeding"),
    "related_material": root.findtext(".//data/record/relatedmaterial"),
    "arrangement": root.findtext(".//data/record/arrangement"),
    "accruals": root.findtext(".//data/record/accruals"),
    }

def _ms(root: etree._Element) -> dict:
    return {
    "locus": root.findtext(".//data/record/locus"),
    "incipit": root.findtext(".//data/record/incipit"),
    "explicit": root.findtext(".//data/record/explicit"),
    "rubric": root.findtext(".//data/record/rubric"),
    "final_rubric": root.findtext(".//data/record/finalRubric"),
    }

def _not(root: etree._Element) -> dict:
    return {
    "music_key": [mk.findtext(".") for mk in root.xpath(".//data/record/musicKey")],
    "music_key_other": root.findtext(".//data/record/musicKey"),
    "music_medium": [mm.findtext(".") for mm in root.xpath(".//data/record/musicMedium")],
    "music_medium_other": root.findtext(".//data/record/musicMediumOther"),
    "music_notation": [mn.findtext(".") for mn in root.xpath(".//data/record/musicNotation")],
    }

