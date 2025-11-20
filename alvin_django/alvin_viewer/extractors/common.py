from typing import Any, Dict, List, Callable, Optional, Union
from collections import defaultdict
from lxml import etree
import requests
from django.utils import translation
from django.core.cache import cache

from ..xmlutils.nodes import attr, element, elements, first, text, texts
from .mappings import person, place, organisation
from ..services.text_collector import get_item_dict

# ------------------
# DRY
# ------------------

# HELPERS ----------

ITEMS_DICT = get_item_dict()

def _xp(rt: str, xpath: str, absolute: bool = False) -> str:
    return xpath if absolute else f"data/{rt}/{xpath}"

def _norm_rt(record_type: str) -> str:
    return record_type.replace("alvin-", "") if record_type.startswith("alvin-") else record_type

def collect(root: etree._Element, xpath: str, map_fn: Callable[[etree._Element], Optional[dict]]) -> List[dict]:
    out: List[dict] = []
    for n in root.xpath(xpath) or []:
        try:
            item = map_fn(n)
            if item:
                out.append(item)
        except Exception:
            continue
    return out

def compact(d: Dict[str, Any]) -> Dict[str, Any]:
    return {k: v for k, v in d.items() if v not in (None, "", [], {}, ())}


# COMMON -----------

def _last_updated(root, record_type):
    last_updated = elements(root, _xp(record_type, "recordInfo/updated/tsUpdated"))
    return text(last_updated[-1], ".") if text(last_updated[-1], ".") is not None else None

def identifiers(root: etree._Element, xp: str):
    return collect(root, xp, lambda f: compact({
        "label": _get_label(f),
        "type": _get_attribute_item(attr(f, "./@type")), 
        "identifier": text(f, ".")
    }))

def common(root: etree._Element, record_type: str) -> Dict[str, Any]:
    rt = _norm_rt(record_type)
    return {
        "id": text(root, _xp(rt, "recordInfo/id")),
        "created": text(root, _xp(rt, "recordInfo/tsCreated")),
        "last_updated": _last_updated(root, rt),
        "source_xml": text(root, "actionLinks/read/url"),
        "record_type": record_type,
    }

# TITLES / NAMES ---

def titles(root: etree._Element, xp: str) -> list[dict] or dict:    
    if "variant" in xp:
        return collect(root, xp, lambda f: compact({
            "label": _get_label(f),
            "type": _get_attribute_item(attr(f, "./@variantType")),
            "main_title": text(f, "mainTitle"),
            "subtitle": text(f, "subtitle"),
            "orientation_code": text(f, "orientationCode"),
        }))
    
    target = element(root, xp)
    if target is None:
        return ""

    title = {
        "label": _get_label(target),
        "main_title": text(target, "mainTitle"),
        "subtitle": text(target, "subtitle"),
        "orientation_code": text(target, "orientationCode")
        }
    return title

def names(node: etree._Element, xp: str, name_parts: Dict[str, str]) -> Dict[str, dict]:

    targets = elements(node, xp)
    if targets is None:
        return {}
    result: Dict[str, dict] = {}
    per_lang: Dict[str, Union[dict, List[dict]]] = {}

    for target in targets:
        
        result["label"] = _get_label(element(target, "name")) or _get_label(element(target, "geographic"))

        d: Dict[str, str] = {}
        for key, xpath in name_parts.items():
            el = element(target, xpath)
            d[key] = (el.text or "").strip() if el is not None else ""

        lang = attr(target, "./@lang")
        label_lang = _get_attribute_item(attr(target, "./@lang")) or None
        variant_type = _get_attribute_item(attr(target, "./@variantType")) or None
        
        entry = {**d, "variant_type": variant_type, "label_lang": label_lang}
        
        if lang not in per_lang:
            per_lang[lang] = entry
        else:
            existing = per_lang[lang]
            if isinstance(existing, list):
                existing.append(entry)
            else:
                per_lang[lang] = [existing, entry]

    result["names"] = per_lang
    return result

def authority_names(node: etree._Element, name_parts: Dict[str, str]) -> Dict[str, Dict[str, str]]:
    result: Dict[str, str] = {}
    
    for name in elements(node, ".//authority"):
        lang = name.get("lang")
        result[lang] = {key: name.findtext(xpath) for key, xpath in name_parts.items()}
    return result

# DATES ------------

def a_date(node: etree._Element, kind: str) -> Dict:
    target = _get_target(node, f"{kind}Date")
    if target is None:
        return None    
    return compact({
        "label": _get_label(target),
        "year": text(target, "date/year"),
        "month": text(target, "date/month"),
        "day": text(target, "date/day"),
        "era": _get_value(target, "date/era")
    })

def dates(node: etree._Element, xp: str, start_tag: str, end_tag: str) -> Dict:
    return collect(node, xp, lambda f: compact({
        "label": _get_label(f),
        "type": _get_attribute_item(attr(f, "./@type")),
        "dates": {
            "label": _get_attribute_item(attr(f, "./@type")),
            "start_date": a_date(f, f"{start_tag}"),
            "end_date": a_date(f, f"{end_tag}"),
            "date_note": text(f, "note")
        }
    }))

# LINKED DATA ------

def electronic_locators(node: etree._Element, xp: str) -> List[Dict[str, str]]:
    return collect(node, xp, lambda f: compact({
        "label": _get_label(f),
        "url": text(f, "url"),
        "display_label": text(f, "displayLabel"),
    }))

def origin_places(node: etree._Element, xp: str) -> dict:
    return collect(node, xp, lambda f: compact({
        "label": _get_label(f),
        "id": text(f, "place/linkedRecordId"),
        "name": names(f, "place/linkedRecord/place/authority", place["AUTH_NAME"]),
        "country": decorated_list(f, "country"),
        "historical_country": decorated_list(f, "historicalCountry"),
        "certainty": text(f, "certainty"),
    }))

def related_records(node: etree._Element, xp: str, type: str) -> List[Dict[str, str]]:
    target = element(node, xp)
    if target is None:
        return None
    return {
        "label": _get_label(target),
        "records": collect(node, xp, lambda f: compact({
            "type": _get_attribute_item(attr(f, "./@relatedToType")), # Get relatedTo type
            "id": text(f, f"{type}/linkedRecordId"),
            "main_title": titles(f, f"{type}/linkedRecord/{type}/title"),
            "parts": [{
                "type": _get_attribute_item(attr(part, "./@partType")), # Get part type
                "typeattr": attr(part, "./@partType"),
                "number": text(part, "partNumber"),
                "extent": text(part, "extent"),
            } for part in elements(f, "part")],
        }))
    }

def related_works(node: etree._Element, xp: str) -> List[Dict[str, str]]:
    target = _get_target(node, xp)
    if target is None:
        return None
    return {
        "label": _get_label(target),
        "records": collect(node, xp, lambda f: compact({
            "type": _get_value(f, "linkedRecord/work/formOfWork"),
            "id": text(f, "linkedRecordId"),
            "title": first(titles(f, "linkedRecord/work/title")),
        }))
    }


def location(node: etree._Element, resource_type: str, xp: str) -> Dict[str, str]:
    if node is None:
        return {}

    loc = first(elements(node, _xp(resource_type, xp)))
    names = {}
    
    for e in elements(loc, "linkedRecord/location/authority"):
        lang = attr(e, "./@lang")
        names[lang] = {key: text(e, xpath) for key, xpath in organisation["AUTH_NAME"].items()}

    return {
        "label": _get_label(loc),
        "id": text(loc, "linkedRecordId"),
        "name": names,
        }

def agents(node: etree._Element, xp: str) -> dict:
    if node is None:
        return {}
    
    agents = []
    
    for agent in elements(node, xp):
        AN = person["AUTH_NAME"] if attr(agent, './@type') == 'person' else organisation["AUTH_NAME"]
        agents.append({
            "label": _get_label(agent),
            "type": None if attr(agent, './@type') is None else f"alvin-{attr(agent, './@type')}",
            "id": text(agent, ".//linkedRecordId"),
            "name": names(agent, ".//authority", AN),
            "role": [_get_value(e) for e in elements(agent, "role")],
            "certainty": text(agent, "certainty"),
        })

    return agents

def related_authority(node: etree._Element, xp: str, authority: str) -> dict:
    if node is None:
        return {}
    
    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    targets = elements(node, xp)
    if targets is None:
        return {}
    
    related = {
        "label": _get_label(first(targets)),
        "records":[{
            "id": text(t, f"{authority}/linkedRecordId"),
            "type": attr(t, "./@type"),
            "name": names(t, f"{authority}/linkedRecord/{authority}/authority", AN[authority]),
            } for t in targets]
    }
    
    return compact(related)

def subject_authority(node: etree._Element, resource_type: str, authority: str) -> dict:
    if node is None:
        return {}
    
    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    target = element(node, _xp(resource_type, f"subject[@type = '{authority}']"))
    if target is None:
        return {}
    
    return {
        "label": _get_label(target),
        "records": [{
            "id": text(e, f"{authority}/linkedRecordId"),
            "name": names(e, f"{authority}/linkedRecord/{authority}/authority", AN[authority]),
            } for e in elements(node, _xp(resource_type, f"subject[@type = '{authority}']"))]
        }

# COMPONENTS -------

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
            "title": titles(comp, "title"),
            "agents": agents(comp, "agent"),
            "place":  related_authority(comp, "place", "place"),
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

# ------------------
# DECORATED METADATA
# ------------------

def _get_value(node: etree._Element | None = None, xp: str = "") -> str:
    if node is None:
        return {}
    if xp != "":
        target = element(node, xp)
        return target.get(f"_value_{_get_lang()}") if target is not None else node.get(f"_value_{_get_lang()}")
    
    return node.get(f"_value_{_get_lang()}")
    
def _get_label(node: etree._Element | None = None) -> str:
    if node is None:
        return {}
    label = node.get(f"_{_get_lang()}")
    return label if label not in (None, "") else None

def _get_lang():
    return translation.get_language()

def _get_target(node, xp):
    if node is None:
        return {}
    target = element(node, xp)
    return target

def decorated_text(node: etree._Element | None, xp: str | None = None) -> dict:
    target = _get_target(node, xp)
    if target is None:
        return None
    txt = {
        "label": _get_label(target),
        "text": text(node, xp)
    }
    return compact(txt)

def decorated_texts(node: etree._Element | None, xp: str | None = None) -> dict:
    target = _get_target(node, xp)
    if target is None:
        return None
    txt = {
        "label": _get_label(target),
        "texts": texts(node, xp)
    }
    return compact(txt)

def decorated_texts_with_type(node: etree.Element, xp: str, tag: str, textType: str | None = None) -> dict:
    target = _get_target(node, xp)
    if target is None:
        return None
    return {
        "label": _get_label(target),
        "texts": [{"type": _get_attribute_item(attr(e, textType)), "text": text(e, ".")} for e in elements(node, f"{xp}/{tag}")]
    }

def decorated_list(node: etree._Element, xp: str) -> dict:
    target = _get_target(node, xp)
    if target is None:
        return None
    return {
            "label": _get_label(target),
            "items": [_get_value(e) for e in elements(node, xp)],
            "code": text(node, xp),
    }

def decorated_list_item(node: etree._Element, xp: str = None) -> str:
    target = _get_target(node, xp)
    if target is None:
        return None
    return {"label": _get_label(target),
            "item": _get_value(node.find(xp)),
            "code": text(node, xp)}

def decorated_list_item_with_text(node: etree._Element, xp: str, item: str, item_text: str) -> str:
    target = _get_target(node, xp)
    if target is None:
        return None
    return {"label": _get_label(target),
            "item": _get_value(element(node, f"{xp}/{item}")),
            "text": text(node, f"{xp}/{item_text}")
        }

# -------------------
# ATTRIBUTE COLLECTION ITEMS
# -------------------

def _get_attribute_item(item: str) -> str:
    return ITEMS_DICT.get(item, {}).get(_get_lang(), None)
