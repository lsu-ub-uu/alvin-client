from lxml import etree
from typing import Dict, List
from ..xmlutils.nodes import text, texts, elements

def authority_names(root: etree._Element, name_parts: Dict[str, str]) -> Dict[str, Dict[str, str]]:
    result = {}
    for name in root.xpath("//authority"):
        lang = name.get("lang")
        result[lang] = {key: name.findtext(xpath) for key, xpath in name_parts.items()}
    return result

def variant_names_list(root: etree._Element, mapping: Dict[str, str]) -> List[Dict[str, str]]:
    out: List[Dict[str, str]] = []
    for node in root.xpath("//variant"):
        d: Dict[str, str] = {}
        for key, xp in mapping.items():
            if xp.startswith("./@"):
                d[key] = node.get(xp[3:]) or ""
            else:
                d[key] = node.findtext(xp) or ""
        out.append(d)
    return out

def electronic_locators(node: etree._Element):
    return [{
        "url": loc.findtext("./url"),
        "display_label": loc.findtext("./displayLabel"),
    } for loc in node.xpath(".//electronicLocator")]

def agents(node: etree._Element):
    return [{
        "type": f"alvin-{agent.get('type')}",
        "id": agent.findtext(".//linkedRecordId"),
        "role": texts(agent, "./role"),
        "certainty": agent.findtext("./certainty"),
    } for agent in node.xpath(".//agent")]

def origin_places(node: etree._Element):
    return [{
        "id": op.findtext(".//linkedRecordId"),
        "country": op.findtext(".//country"),
        "historical_country": op.findtext(".//historicalCountry"),
        "certainty": op.findtext(".//certainty"),
        "publication": texts(op, "..//publication"),
    } for op in node.xpath(".//originPlace")]

def related(node: etree._Element, typ: str):
    return [{
        "id": r.findtext(".//linkedRecordId"),
        "url": r.findtext(".//url"),
    } for r in node.xpath(f".//related[@type='{typ}']")]

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
            "main_title": comp.findtext("./title/mainTitle"),
            "sub_title": comp.findtext("./title/subTitle"),
            "level": comp.findtext("./level"),
            "unitid": comp.findtext("./unitid"),
            "related_records": related_records(comp, "./relatedTo"),
            "agents": agents(comp),
            "start_date": get_dates("start", comp),
            "end_date": get_dates("end", comp),
            "place": comp.findtext("./place/linkedRecordId"),
            "display_date": comp.findtext("./originDate/displayDate"),
            "electronic_locators": electronic_locators(comp),
            "note": comp.findtext("./note"),
            "access_policy": comp.findtext("./accessPolicy"),
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
        node.findtext(f".//{kind}Date//year"),
        node.findtext(f".//{kind}Date//month"),
        node.findtext(f".//{kind}Date//day"),
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