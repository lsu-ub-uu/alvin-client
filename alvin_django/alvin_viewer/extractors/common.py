from django.utils import translation
from lxml import etree
from typing import Dict, List
from ..xmlutils.nodes import attr, element, elements, first, text, texts
from .mappings import person
from .mappings import place, organisation

def _get_lang():
    return translation.get_language()

def _get_value(node: etree._Element | None = None, xp: str = "") -> str:
    if xp is not "":
        node = element(node, xp)
    if node is not None:
        return node.get(f"_value_{_get_lang()}")
    
def _get_label(element: etree._Element | None = None) -> str:
    if element is not None:
        return element.get(f"_{_get_lang()}")

def _xp(path: str, absolute: bool = False) -> str:
    base = "data/record/"
    return path if absolute else f"{base}{path}"

def _titles(node: etree._Element, xp: str):
    titles = [{
        "label": _get_label(e),
        "type": attr(e, "./@variantType"),
        "main_title": text(e, "mainTitle"),
        "subtitle": text(e, "subtitle"),
        "orientation_code": text(e, "orientationCode"),
    } for e in elements(node, xp)]
    return titles or None

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

def electronic_locators(root: etree._Element, xp: str) -> List[Dict[str, str]]:
    return [{
        "label": _get_label(loc),
        "url": text(loc, "url"),
        "display_label": text(loc, "displayLabel"),
    } for loc in elements(root, xp)]

def origin_places(root: etree._Element) -> dict:
    return [{
        "label": _get_label(e),
        "id": text(e, "place/linkedRecordId"),
        "name": authority_names(e, place["AUTH_NAME"]),
        "country": decorated_list(e, "country"),
        "historical_country": decorated_list(e, "historicalCountry"),
        "certainty": text(e, "certainty"),
    } for e in elements(root, _xp("originPlace"))]

def related(node: etree._Element, reltype: str) -> List[Dict[str, str]]:
    return [{
        "id": r.findtext(".//linkedRecordId"),
        "url": r.findtext(".//url"),
    } for r in node.xpath(f".//related[@type='{reltype}']")]

def related_records(node: etree._Element, xp: str) -> List[Dict[str, str]]:
    return {
        "label": _get_label(element(node, xp)),
        "records": [{
            "type": attr(e, "./@relatedToType"),
            "id": text(e, "record/linkedRecordId"),
            "title": first(_titles(e, "record/linkedRecord/record/title")),
            "parts": [{
                "type": attr(part, "./@partType"),
                "number": text(part, "partNumber"),
                "extent": text(part, "extent"),
            } for part in e],
        } for e in elements(node, xp)]
    }

def components(nodes: List[etree._Element]) -> Dict[str, str]:
    comps = []
    for comp in nodes:
        sub = components(comp.xpath("./*[contains(name(), 'component')]"))
        md = {
            # Arhchives
            "level": decorated_list_item(comp, "level"),
            "unitid": text(comp, "unitid"),
            # Manuscripts
            "locus": decorated_text(comp, "locus"),
            # Common
            "title": first(_titles(comp, "title")),
            "agents": decorated_agents(comp, "agent"),
            "place": decorated_authority(comp, "place", "place"),
            "related_records": related_records(comp, "relatedTo"),
            "origin_date": first(dates(comp, "originDate", "start", "end")),
            "display_date": decorated_text(comp, "originDate/displayDate"),
            "extent": decorated_text(comp, "extent"),
            "note": decorated_text(comp, "note"),
            "accession_numbers": decorated_texts(comp, "identifier[@type = 'accessionNumber']"),
            "electronic_locators": electronic_locators(comp, "electronicLocator"),
            "access_policy": decorated_text(comp, "accessPolicy")
        }
        if sub:
            md["components"] = sub
        if any(v for v in md.values() if v):
            comps.append(md)
    return comps

def a_date(node: etree._Element, kind: str) -> Dict:
    
    return {
        "year": text(node, f"{kind}Date/date/year"),
        "month": text(node, f"{kind}Date/date/month"),
        "day": text(node, f"{kind}Date/date/day"),
        #"era": text(node, f"{kind}Date/date/era"),
        "era": _get_value(node, f"{kind}Date/date/era")
    }

def dates(root: etree._Element, xp: str, start: str, end: str) -> Dict:
    return [{
        "label": _get_label(e),
        "type": attr(e, "./@type"),
        "dates": {
            "start_date": a_date(e, f"{start}"),
            "end_date": a_date(e, f"{end}"),
            "date_note": text(e, "note")
        },

    } for e in elements(root, xp)]

# Decorated
def decorated_location(root: etree._Element, xp: str) -> Dict[str, str]:

    loc = first(elements(root, _xp(xp)))
    names = {}
    
    for e in elements(loc, "linkedRecord/location/authority"):
        lang = attr(e, "./@lang")
        names[lang] = {key: text(e, xpath) for key, xpath in organisation["AUTH_NAME"].items()}

    return {
        "label": _get_label(loc),
        "id": text(loc, "linkedRecordId"),
        "name": names,
        }

def decorated_agents(node: etree._Element, xp: str) -> dict:

    agents = []
    
    for agent in elements(node, xp):
        AN = person["AUTH_NAME"] if attr(agent, './@type') == 'person' else organisation["AUTH_NAME"]
        agents.append({
            "label": _get_label(agent),
            "type": None if attr(agent, './@type') is None else f"alvin-{attr(agent, './@type')}",
            "id": text(agent, ".//linkedRecordId"),
            "name": authority_names(agent, AN),
            "role": [_get_value(e) for e in elements(agent, "role")],
            "certainty": text(agent, "certainty"),
        })

    return agents

def decorated_authority(root: etree._Element, xp: str, authority: str) -> dict:
    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    label_element = element(root, xp)
    if label_element is not None:
        return {
            "label": _get_label(label_element),
            "records":[{
                "id": text(label_element, f"linkedRecordId"),
                "name": authority_names(label_element, AN[authority]),
                }]
        }

def decorated_subject_authority(root: etree._Element, authority: str) -> dict:
    
    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    label_element = root.find(_xp(f"subject[@type = '{authority}']"))
    return {
        "label": _get_label(label_element),
        "records": [{
            "id": text(e, f"{authority}/linkedRecordId"),
            "name": authority_names(e, AN[authority]),
            } for e in elements(root, _xp(f"subject[@type = '{authority}']"))]
        }

def decorated_text(root: etree.Element, xp: str) -> dict:
    return {
        "label": _get_label(root.find(xp)),
        "text": text(root, xp)
    }

def decorated_texts(root: etree.Element, xp: str | None = None) -> dict:
    return {
        "label": _get_label(root.find(xp)),
        "texts": texts(root, xp)
    }

def decorated_texts_with_type(root: etree.Element, xp: str, element: str, textType: str | None = None) -> dict:
    return {
        "label": _get_label(root.find(_xp(xp))),
        "texts": [{"type": attr(e, textType), "text": text(e, ".")} for e in elements(root, _xp(f"{xp}/{element}"))]
    }

def decorated_list_item(node: etree._Element, xp: str = None) -> str:
    return {"label": _get_label(element(node, xp)), "item": _get_value(node.find(xp))}

def decorated_list(node: etree._Element, xp: str) -> dict:
    return {
            "label": _get_label(node.find(xp)),
            "items": [_get_value(e) for e in elements(node, xp)],
            "code": text(node, _xp(xp))
    }