from lxml import etree
from typing import Dict, List
from ..xmlutils.nodes import text, texts, elements

def authority_names(root: etree._Element, name_parts: Dict[str, str]) -> Dict[str, Dict[str, str]]:
    result: Dict[str, str] = {}
    for name in elements(root, ".//authority"):
        lang = name.get("lang")
        result[lang] = {key: name.findtext(xpath) for key, xpath in name_parts.items()}
    return result

def variant_names_list(root: etree._Element, mapping: Dict[str, str]) -> List[Dict[str, str]]:
    out: List[Dict[str, str]] = []
    for node in elements(root, "//variant"):
        d: Dict[str, str] = {}
        for key, xp in mapping.items():
            if xp.startswith("./@"):
                d[key] = node.get(xp[3:]) or ""
            else:
                d[key] = node.findtext(xp) or ""
        out.append(d)
    return out

def electronic_locators(root: etree._Element):
    return [{
        "url": text(loc, "url"),
        "display_label": text(loc, "displayLabel"),
    } for loc in elements(root, "data/record/electronicLocator")]

def origin_places(node: etree._Element):
    return [{
        "id": op.findtext(".//linkedRecordId"),
        "country": op.findtext(".//country"),
        "historical_country": op.findtext(".//historicalCountry"),
        "certainty": op.findtext(".//certainty"),
    } for op in node.xpath(".//data/record/originPlace")]

def related(node: etree._Element, reltype: str):
    return [{
        "id": r.findtext(".//linkedRecordId"),
        "url": r.findtext(".//url"),
    } for r in node.xpath(f".//related[@type='{reltype}']")]

def related_records(node: etree._Element, path: str):
    return [{
        "type": rec.get("relatedToType"),
        "id": rec.findtext("./record/linkedRecordId"),
        "parts": [{
            "type": part.get("partType"),
            "number": part.findtext("./partNumber"),
            "extent": part.findtext("./extent"),
        } for part in rec.xpath("./part")],
    } for rec in node.xpath(path)]

def components(nodes: List[etree._Element]):
    comps = []
    for comp in nodes:
        sub = components(comp.xpath("./*[contains(name(), 'component')]"))
        md = {
            "title": {
                "main_title": comp.findtext("./title/mainTitle"),
                "subtitle": comp.findtext("./title/subtitle"),
                "orientation_code": comp.findtext("./title/orientationCode")
            },
            "level": text(comp, "level"),
            "unitid": text(comp, "unitid"),
            "related_records": related_records(comp, "relatedTo"),
            "agents": agents(comp, "agent"),
            "start_date": get_dates("start", comp.find("./originDate")),
            "end_date": get_dates("end", comp.find("./originDate")),
            "place": comp.findtext("./place/linkedRecordId"),
            "display_date": comp.findtext("./originDate/displayDate"),
            "extent": comp.findtext("./extent"),
            "electronic_locators": electronic_locators(comp),
            "note": comp.findtext("./note"),
            "access_policy": comp.findtext("./accessPolicy"),
            "accession_numbers": [number.findtext(".") for number in comp.findall("./identifier[@type = 'accessionNumber']")]
        }
        if sub:
            md["components"] = sub
        if any(v for v in md.values() if v):
            comps.append(md)
    return comps

def get_dates(kind: str, node: etree._Element) -> str:
    if node is None:
        return ""
    parts = list(filter(None, [
        text(node, f".//{kind}Date//year"),
        text(node, f".//{kind}Date//month"),
        text(node, f".//{kind}Date//day"),
    ]))
    date_str = "-".join(parts)
    era = node.findtext(f".//{kind}Date//era")
    return f"{date_str} {era}" if era else date_str

def get_date_other(node: etree._Element):
    return [{
        "start_date": get_dates("start", date),
        "end_date": get_dates("end", date),
        "type": date.get("type"),
        "date_note": date.findtext("./note"),
    } for date in node.xpath(".//dateOther")]