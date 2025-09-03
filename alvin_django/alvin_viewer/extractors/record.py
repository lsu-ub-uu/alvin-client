from lxml import etree
from .common import origin_places, electronic_locators, agents, related_records, components, get_dates, get_date_other

def _titles(root: etree._Element, xp: str):
    return [{
        "type": t.get("variantType"),
        "main_title": t.findtext("./mainTitle"),
        "subtitle": t.findtext("./subtitle"),
        "orientation_code": t.findtext("./orientationCode"),
    } for t in root.xpath(xp)]

def _subject_authority(root: etree._Element, typ: str):
    return [{"id": a.findtext(".//linkedRecordId")} for a in root.xpath(f"//record/subject[@type = '{typ}']")]

def _dimensions(root: etree._Element):
    return [{
        "scope": d.findtext("./scope"),
        "height": d.findtext("./height"),
        "width": d.findtext("./width"),
        "depth": d.findtext("./depth"),
        "diameter": d.findtext("./diameter"),
        "unit": d.findtext("./unit"),
    } for d in root.xpath("//data/record/dimensions")]

def _physical_description_notes(root: etree._Element):
    return [{"type": n.get("noteType"), "note": n.findtext(".")} for n in root.xpath("//physicalDescription/note")]

def _notes(root: etree._Element):
    return [{"type": n.get("noteType"), "note": n.findtext(".")} for n in root.xpath("//record/note")]

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

def _files_brief(root: etree._Element):
    # Lättviktig representation – undvik att returnera hela <file>-noder
    out = []
    for f in root.xpath("//record//file"):
        url = f.findtext(".//url")
        iiif_server = f.findtext(".//iiif/server")
        iiif_identifier = f.findtext(".//iiif/identifier")
        height = f.findtext(".//master/height")
        width = f.findtext(".//master/width")
        out.append({
            "url": url,
            "iiif_server": iiif_server,
            "iiif_identifier": iiif_identifier,
            "height": int(height) if (height and height.isdigit()) else height,
            "width": int(width) if (width and width.isdigit()) else width,
        })
    return out

def extract(root: etree._Element) -> dict:
    return {
        "type_of_resource": root.findtext(".//data/record/typeOfResource"),
        "main_title": _titles(root, ".//data/record/title"),
        "variant_titles": _titles(root, ".//data/record/variantTitle"),
        "agents": agents(root, ".//data/record/agent"),
        "edition_statement": root.findtext(".//record/editionStatement"),
        "publications": [p.findtext(".") for p in root.xpath("./data/record/publication")],
        "origin_places": origin_places(root),
        "start_date": get_dates("start", root.find("./data/record/originDate")),
        "end_date": get_dates("end", root.find("./data/record/originDate")),
        "display_date": root.findtext(".//data/record/originDate/displayDate"),
        "date_other": get_date_other(root),
        "physical_location": {
            "held_by": root.findtext(".//physicalLocation/heldBy/location/linkedRecordId"),
            "sublocation": root.findtext(".//physicalLocation/sublocation"),
            "shelf_mark": root.findtext(".//physicalLocation/shelfMark"),
            "former_shelf_mark": [s.findtext(".") for s in root.xpath("//physicalLocation/formerShelfMark")],
            "subcollection": [sc.findtext(".") for sc in root.xpath("//physicalLocation/subcollection/*")],
            "note": root.findtext(".//physicalLocation/note[@noteType='general']"),
        },
        "languages": [l.findtext(".") for l in root.xpath("//data/record/language")],
        "description_languages": [l.findtext(".") for l in root.xpath("//data/record/adminMetadata/descriptionLanguage")],
        "base_material": [m.findtext(".") for m in root.xpath("//baseMaterial")],
        "extent": root.findtext(".//record/extent"),
        "dimensions": _dimensions(root),
        "physical_description_notes": _physical_description_notes(root),
        "notes": _notes(root),
        "summary": root.findtext(".//record/summary"),
        "transcription": root.findtext(".//record/transcription"),
        "table_of_contents": root.findtext(".//record/tableOfContents"),
        "literature": root.findtext(".//record/listBibl"),
        "access_policy": root.findtext(".//record/accessPolicy"),
        "identifiers": _identifiers(root),
        "genre_form": [g.findtext(".") for g in root.xpath("//data/record/genreForm")],
        "subjects": _subjects_misc(root),
        "subject_person": _subject_authority(root, "person"),
        "subject_organisation": _subject_authority(root, "organisation"),
        "subject_place": _subject_authority(root, "place"),
        "classifications": _classifications(root),
        "related_records": related_records(root, "./data/record/relatedTo"),
        "electronic_locators": electronic_locators(root),
        "files": root.find(".//file"),
        "components": components(root.xpath("//descriptionOfSubordinateComponents/component01")),
    }