from lxml import etree
from typing import Dict, List
import requests
from django.utils import translation

from ..xmlutils.nodes import attr, element, elements, first, text, texts
from .mappings import person, place, organisation

def _get_lang():
    return translation.get_language()

def _get_value(node: etree._Element | None = None, xp: str = "") -> str:
    if node is not None:
        if xp != "":
            node = element(node, xp)
        return node.get(f"_value_{_get_lang()}")
    
def _get_label(element: etree._Element | None = None) -> str:
    if element is not None:
        return element.get(f"_{_get_lang()}")

def _xp(path: str, absolute: bool = False) -> str:
    base = "data/record/"
    return path if absolute else f"{base}{path}"


    if item is None:
        return "Item not found"
    
    "Content-Type": "application/vnd.cora.record+xml",
    "Accept": "application/vnd.cora.record+xml",
    }

    try:
        r = requests.get(f"https://cora.alvin-portal.org/rest/record/text/{item}{suffix}", headers=xml_headers)
        root = etree.fromstring(r.content)
        return text(root, f"data/text/textPart[@lang = '{_get_lang()}']/text") or text(root, "data/text/textPart/text")
    except:
        return f"Couldn't fetch item from Cora: {item}"

def _titles(node: etree._Element, xp: str):
    titles = [{
        "label": _get_label(e),
        "type": _get_attribute_item(attr(e, "./@variantType"), "ItemText"),
        "main_title": text(e, "mainTitle"),
        "subtitle": text(e, "subtitle"),
        "orientation_code": text(e, "orientationCode"),
    } for e in elements(node, xp)]
    return titles or None

def authority_names(node: etree._Element, name_parts: Dict[str, str]) -> Dict[str, Dict[str, str]]:
    result: Dict[str, str] = {}
    for name in elements(node, ".//authority"):
        lang = name.get("lang")
        result[lang] = {key: name.findtext(xpath) for key, xpath in name_parts.items()}
    return result

def variant_names_list(node: etree._Element, mapping: Dict[str, str]) -> List[Dict[str, str]]:
    out: List[Dict[str, str]] = []
    for node in elements(node, "//variant"):
        d: Dict[str, str] = {}
        for key, xp in mapping.items():
            if xp.startswith("./@"):
                d[key] = node.get(xp[3:]) or ""
            else:
                d[key] = node.findtext(xp) or ""
        out.append(d)
    return out

def electronic_locators(node: etree._Element, xp: str) -> List[Dict[str, str]]:
    return [{
        "label": _get_label(loc),
        "url": text(loc, "url"),
        "display_label": text(loc, "displayLabel"),
    } for loc in elements(node, xp)]

def origin_places(node: etree._Element, xp: str) -> dict:
    return [{
        "label": _get_label(e),
        "id": text(e, "place/linkedRecordId"),
        "name": authority_names(e, place["AUTH_NAME"]),
        "country": decorated_list(e, "country"),
        "historical_country": decorated_list(e, "historicalCountry"),
        "certainty": text(e, "certainty"),
    } for e in elements(node, xp)]

def related(node: etree._Element, reltype: str) -> List[Dict[str, str]]:
    return [{
        "id": r.findtext(".//linkedRecordId"),
        "url": r.findtext(".//url"),
    } for r in node.xpath(f".//related[@type='{reltype}']")]

def related_records(node: etree._Element, xp: str, type: str) -> List[Dict[str, str]]:
    return {
        "label": _get_label(element(node, xp)),
        "records": [{
            "type": _get_attribute_item(attr(e, "./@relatedToType"), "ItemText"), # Get relatedTo type
            "id": text(e, f"{type}/linkedRecordId"),
            "title": first(_titles(e, f"{type}/linkedRecord/{type}/title")),
            "parts": [{
                "type": _get_attribute_item(attr(part, "./@partType"), "ItemText"), # Get part type
                "typeattr": attr(part, "./@partType"),
                "number": text(part, "partNumber"),
                "extent": text(part, "extent"),
            } for part in elements(e, "part")],
        } for e in elements(node, xp)]
    }

def related_works(node: etree._Element, xp: str) -> List[Dict[str, str]]:
    label_element = element(node, xp)
    if label_element is not None:
        return {
            "label": _get_label(label_element),
            "records": [{
                "type": _get_value(e, "linkedRecord/work/formOfWork"),
                "id": text(e, "linkedRecordId"),
                "title": first(_titles(e, "linkedRecord/work/title")),
            } for e in elements(node, xp)]
        }

def components(nodes: List[etree._Element]) -> Dict[str, str]:
    comps = []
    for comp in nodes:
        sub = components(comp.xpath("./*[contains(name(), 'component')]|./*[contains(name(), 'msItem')]"))
        md = {
            # Archives
            "level": decorated_list_item(comp, "level"),
            "unitid": text(comp, "unitid"),

            # Manuscripts
            "locus": decorated_text(comp, "locus"),
            "languages": decorated_list(comp, "language"),
            "origin_places": origin_places(comp, "originPlace"),
            "physical_description_notes": decorated_texts_with_type(comp, "physicalDescription", "note", "./@noteType"),
            "locus": decorated_text(comp, "locus"),
            "incipit": decorated_text(comp, "incipit"),
            "explicit": decorated_text(comp, "explicit"),
            "rubric": decorated_text(comp, "rubric"),
            "final_rubric": decorated_text(comp, "finalRubric"),
            "literature": decorated_text(comp, "listBibl"),
            "literature": decorated_text(comp, "listBibl"),
            "notes": decorated_texts_with_type(comp, "note", ".", "./@noteType"),

            # Common
            "title": first(_titles(comp, "title")),
            "agents": decorated_agents(comp, "agent"),
            "place": decorated_authority(comp, "place", "place"),
            "related_records": related_records(comp, "relatedTo", "record"),
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
        "era": _get_value(node, f"{kind}Date/date/era")
    }

def dates(node: etree._Element, xp: str, start_tag: str, end_tag: str) -> Dict:
    return [{
        "label": _get_label(e),
        "type": attr(e, "./@type"),
        "dates": {
            "label": _get_attribute_item(attr(e, "./@type"), "DateTypeItemText"),
            "start_date": a_date(e, f"{start_tag}"),
            "end_date": a_date(e, f"{end_tag}"),
            "date_note": text(e, "note")
        },

    } for e in elements(node, xp)]

# Decorated
def decorated_location(node: etree._Element, xp: str) -> Dict[str, str]:
    if node is None:
        return {}

    loc = first(elements(node, _xp(xp)))
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
    if node is None:
        return {}
    
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

def decorated_authority(node: etree._Element, xp: str, authority: str) -> dict:
    if node is None:
        return {}
    
    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    target = element(node, xp)

    return {
        "label": _get_label(target),
        "records":[{
            "id": text(target, f"linkedRecordId"),
            "name": authority_names(target, AN[authority]),
            }]
    }

def decorated_subject_authority(node: etree._Element, authority: str) -> dict:
    if node is None:
        return {}
    
    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    target = element(node, _xp(f"subject[@type = '{authority}']"))
    return {
        "label": _get_label(target),
        "records": [{
            "id": text(e, f"{authority}/linkedRecordId"),
            "name": authority_names(e, AN[authority]),
            } for e in elements(node, _xp(f"subject[@type = '{authority}']"))]
        }

def decorated_text(node: etree._Element | None, xp: str | None = None) -> dict:
    if node is None:
        return {}
    target = element(node, xp)
    return {
        "label": _get_label(target),
        "text": text(node, xp)
    }

def decorated_texts(node: etree._Element | None, xp: str | None = None) -> dict:
    if node is None:
        return {}
    target = element(node, xp)
    return {
        "label": _get_label(target),
        "texts": texts(node, xp)
    }

def decorated_texts_with_type(node: etree.Element, xp: str, tag: str, textType: str | None = None) -> dict:
    if node is None:
        return {}
    target = element(node, xp)
    return {
        "label": _get_label(target),
        "texts": [{"type": _get_attribute_item(attr(e, textType)), "text": text(e, ".")} for e in elements(node, f"{xp}/{tag}")]
    }

def decorated_list(node: etree._Element, xp: str) -> dict:
    if node is None:
        return {}
    target = element(node, xp)
    return {
            "label": _get_label(target),
            "items": [_get_value(e) for e in elements(node, xp)],
            "code": text(node, xp),
    }

def decorated_list_item(node: etree._Element, xp: str = None) -> str:
    if node is None:
        return {}
    target = element(node, xp)
    return {"label": _get_label(target),
            "item": _get_value(node.find(xp)),
            "code": text(node, xp)}

def decorated_list_item_with_text(node: etree._Element, xp: str, item: str, item_text: str) -> str:
    if node is None:
        return {}
    target = element(node, xp)
    return {"label": _get_label(target),
            "item": _get_value(element(node, f"{xp}/{item}")),
            "text": text(node, f"{xp}/{item_text}")
        }