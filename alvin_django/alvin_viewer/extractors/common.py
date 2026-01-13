from typing import Any, Dict, List, Callable, Optional, Union
from collections import defaultdict
from lxml import etree
import requests
from django.utils import translation
from django.core.cache import cache

from ..xmlutils.nodes import attr, element, elements, first, text, texts
from .mappings import person, place, organisation
from ..services.text_collector import get_item_dict
from .metadata import (Agent, CommonMetadata, DateEntry, DatesBlock, 
                       DatesValue, DecoratedList, DecoratedText, 
                       DecoratedListItem, DecoratedTextWithType, DecoratedTexts, 
                       DecoratedTextsWithType, ElectronicLocator, Identifier, Location,
                       NameEntry, NameValue, NamesBlock,
                       OriginPlace, OriginPlaceBlock, RelatedAuthoritiesBlock,
                       RelatedAuthorityEntry, RelatedRecordsBlock, RelatedRecordEntry, 
                       RelatedRecordPart, TitlesBlock, TitleEntry)


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

def identifiers(root: etree._Element, xp: str) -> List[Identifier]:
    targets = elements(root, xp)
    if not targets:
        return None
    return [Identifier(
        label = _get_label(t),
        type = _get_attribute_item(attr(t, "./@type")), 
        identifier = text(t, ".")
    ) for t in targets]

def common(root: etree._Element, record_type: str) -> Dict[str, Any]:
    rt = _norm_rt(record_type)

    return CommonMetadata(
        id=text(root, _xp(rt, "recordInfo/id")),
        record_type=record_type,
        source_xml=text(root, "actionLinks/read/url"),
        created=decorated_text(root, _xp(rt, "recordInfo/tsCreated")),
        last_updated=decorated_text(root, _xp(rt, "recordInfo/updated/tsUpdated")),
    )

# TITLES / NAMES ---

def titles(root: etree._Element, xp: str) -> TitlesBlock:
    target = element(root, xp)
    if target is None:
        return None
    
    if "variantTitle" in xp:
        targets = elements(root, xp)

        return TitlesBlock(
            label = _get_label(target),
            titles = [TitleEntry(
                type = _get_attribute_item(attr(t, "./@variantType")),
                main_title = text(t, "mainTitle"),
                subtitle = text(t, "subtitle"),
                orientation_code = text(t, "orientationCode"),
            ) for t in targets]
        )

    return TitleEntry(
            label = _get_label(target),
            type = _get_attribute_item(attr(target, "./@variantType")),
            main_title = text(target, "mainTitle"),
            subtitle = text(target, "subtitle"),
            orientation_code = text(target, "orientationCode"),
        )

def names(node: etree._Element, xp: str, name_parts: Dict[str, str]) -> NamesBlock | None:
    targets = elements(node, xp)
    if not targets:
        return None

    per_lang_raw: Dict[str, Union[NameEntry, List[NameEntry]]] = {}
    label: Optional[str] = None

    for target in targets:
        label = _get_label(element(target, "name")) or _get_label(element(target, "geographic")) or label

        parts: Dict[str, str] = {}
        for key, xpath in name_parts.items():
            el = element(target, xpath)
            parts[key] = (el.text or "").strip() if el is not None else ""
            
        lang = attr(target, "./@lang")
        label_lang = _get_attribute_item(attr(target, "./@lang")) or None
        variant_type = _get_attribute_item(attr(target, "./@variantType")) or None

        entry = NameEntry(parts=parts, variant_type=variant_type, label_lang=label_lang)

        if lang not in per_lang_raw:
            per_lang_raw[lang] = entry
        else:
            existing = per_lang_raw[lang]
            if isinstance(existing, list):
                existing.append(entry)
            else:
                per_lang_raw[lang] = [existing, entry]
    
    per_lang: Dict[str, NameValue] = {
        lang: NameValue.from_any(value)
        for lang, value in per_lang_raw.items()
    }

    block = NamesBlock(label=label, names=per_lang)
    if not block.label and not block.names:
        return None
    return block

# DATES ------------

def a_date(node: etree._Element, kind: str) -> DateEntry:
    target = _get_target(node, f"{kind}Date")
    if target is None:
        return None
    return DateEntry(
        label = _get_label(target),
        year = text(target, "date/year"),
        month = text(target, "date/month"),
        day = text(target, "date/day"),
        era = _get_value(target, "date/era")
    )

def dates(node: etree._Element, xp: str, start_tag: str, end_tag: str) -> Dict:
    target = element(node, xp)
    if target is None:
        return None
    return DatesBlock(
        label = _get_label(target),
        type = _get_attribute_item(attr(target, "./@type")),
        dates = DatesValue(
            type = _get_attribute_item(attr(target, "./@type")),
            start_date = a_date(target, f"{start_tag}"),
            end_date = a_date(target, f"{end_tag}"),
            date_note = text(target, "note"),
            display_date = text(target, "displayDate")
        )
    )

# LINKED DATA ------

def electronic_locators(node: etree._Element, xp: str) -> List[Dict[str, str]]:
    targets = elements(node, xp)
    if not targets:
        return None
    return [ElectronicLocator(
        label = _get_label(t),
        url = text(t, "url"),
        display_label = text(t, "displayLabel"),
    ) for t in targets]

def origin_place(node: etree._Element, xp: str) -> OriginPlace:
    target = element(node, xp)
    if target is None:
        return None
    return OriginPlace(
        label = _get_label(target),
        id = text(target, "place/linkedRecordId"),
        name = names(target, "place/linkedRecord/place/authority", place["AUTH_NAME"]),
        country = decorated_list(target, "country"),
        historical_country = decorated_list(target, "historicalCountry"),
        certainty = text(target, "certainty"),
    )

def origin_places(node: etree._Element, xp: str) -> OriginPlaceBlock:
    targets = elements(node, xp)
    if not targets:
        return None
    
    places = [OriginPlace(
        label = _get_label(t),
        id = text(t, "place/linkedRecordId"),
        name = names(t, "place/linkedRecord/place/authority", place["AUTH_NAME"]),
        country = decorated_list(t, "country"),
        historical_country = decorated_list(t, "historicalCountry"),
        certainty = text(t, "certainty"),
    ) for t in targets]
    
    block = OriginPlaceBlock(
        label = _get_label(element(node, xp)),
        places = places
    )

    if block.is_empty():
        return None
    
    return block

def related_records(node: etree._Element, xp: str) -> dict | None:
    target = element(node, xp)
    if target is None:
        return None
    
    rrb = RelatedRecordsBlock(
        label = _get_label(target),
        records = [RelatedRecordEntry(
            type = _get_attribute_item(attr(t, "./@relatedToType")),
            id = text(t, f"record/linkedRecordId"),
            main_title = titles(t, f"record/linkedRecord/record/title"),
            parts = [RelatedRecordPart(
                type = _get_attribute_item(attr(part, "./@partType")),
                typeattr = attr(part, "./@partType"),
                number = text(part, "partNumber"),
                extent = text(part, "extent"),
            ) for part in elements(t, "part")],
        ) for t in elements(node, xp)]
    )
    return rrb

def related_works(node: etree._Element, xp: str) -> List[Dict[str, str]]:
    target = _get_target(node, xp)
    if target is None:
        return {}
    return {
        "label": _get_label(target),
        "records": collect(node, xp, lambda f: compact({
            "type": _get_value(f, "linkedRecord/work/formOfWork"),
            "id": text(f, "linkedRecordId"),
            "title": first(titles(f, "linkedRecord/work/title")),
        }))
    }


def location(node: etree._Element, xp: str) -> Location | None:
    if node is None:
        return None

    loc = element(node, _xp("record", xp))
    
    return Location(
        label = _get_label(loc),
        id = text(loc, "linkedRecordId"),
        names = names(loc, ".//authority", organisation["AUTH_NAME"]),
        )

def agents(node: etree._Element, xp: str) -> NamesBlock:
    target = element(node, xp)
    if target is None:
        return None
    
    return [Agent(
        label = _get_label(agent),
        type = None if attr(agent, './@type') is None else f"alvin-{attr(agent, './@type')}",
        id = text(agent, ".//linkedRecordId"),
        names = names(agent, ".//authority", person["AUTH_NAME"] if attr(agent, './@type') == 'person' else organisation["AUTH_NAME"]),
        roles = decorated_list(agent, "role"),
        certainty = text(agent, "certainty"),
        ) for agent in elements(node, xp)]

def related_authority(node: etree._Element, xp: str, authority: str) -> RelatedAuthoritiesBlock | None:
    if node is None:
        return None
    
    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    targets = elements(node, xp)
    if targets is None:
        return None
    
    related = RelatedAuthoritiesBlock(
        label = _get_label(first(targets)),
        records = [RelatedAuthorityEntry(
            id = text(t, f"{authority}/linkedRecordId"),
            record_type = text(t, (f"{authority}/linkedRecordType")),
            type = _get_attribute_item(attr(t, "./@type")) if attr(t, "./@type") not in ("person", "organisation", "place") else None,
            name = names(t, f"{authority}/linkedRecord/{authority}/authority", AN[authority]),
            )
            for t in targets]
    )
    
    return None if related.is_empty() else related

def subject_authority(node: etree._Element, resource_type: str, authority: str) -> RelatedAuthoritiesBlock | None:
    target = element(node, _xp(resource_type, f"subject[@type = '{authority}']"))
    if target is None:
        return None
    
    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    return RelatedAuthoritiesBlock(
        label = _get_label(target),
        records = [RelatedAuthorityEntry(
            id = text(e, f"{authority}/linkedRecordId"),
            record_type = text(e, (f"{authority}/linkedRecordType")),
            name = names(e, f"{authority}/linkedRecord/{authority}/authority", AN[authority]),
            ) for e in elements(node, _xp(resource_type, f"subject[@type = '{authority}']"))]
        )

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
            "physical_description_notes": decorated_texts_with_type(comp, "physicalLocation", "note", "./@noteType"),
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

def decorated_text(node: etree._Element | None, xp: str | None, parent_xp: str | None = None) -> DecoratedText | None:
    target = _get_target(node, xp)
    if target is None:
        return None
    
    dt = DecoratedText(
        label=_get_label(target),
        parent_label = _get_label(element(node, parent_xp)) if parent_xp else None,
        text=text(node, xp),
    )

    if dt.is_empty():
        return None
    
    return dt


def decorated_texts(node: etree._Element | None, xp: str | None = None) -> DecoratedTexts | None:
    target = _get_target(node, xp)
    if target is None:
        return None
    
    dts = DecoratedTexts(
        label = _get_label(target),
        texts = texts(node, xp)
    )

    if dts.is_empty():
        return None
    return dts

def decorated_texts_with_type(node: etree.Element, xp: str, tag: str, textType: str | None = None) -> DecoratedTextsWithType | None:
    target = _get_target(node, xp)
    if target is None:
        return None
    
    dtwt = DecoratedTextsWithType(
        label = _get_label(target),
        texts = [DecoratedTextWithType(
            type = _get_attribute_item(attr(e, textType)),
            text = text(e, ".")
            ) for e in elements(node, f"{xp}/{tag}")]
    )

    if dtwt.is_empty():
        return None
    return dtwt

def decorated_list(node: etree._Element, xp: str) -> DecoratedList | None:
    target = _get_target(node, xp)
    if target is None:
        return None
    
    dl = DecoratedList(
            label = _get_label(target),
            items = [_get_value(e) for e in elements(node, xp)],
            code = text(node, xp),
    )

    if dl.is_empty():
        return None
    return dl

def decorated_list_item(node: etree._Element, xp: str = None) -> DecoratedListItem | None:
    target = _get_target(node, xp)
    if target is None:
        return None
    
    li = DecoratedListItem(
        label=_get_label(target),
        item=_get_value(element(node, xp)),
        code=text(node, xp),
    )
    
    if li.is_empty():
        return None
    return li

def decorated_list_item_with_text(node: etree._Element, xp: str, item: str, item_text: str) -> dict:
    target = _get_target(node, xp)
    if target is None:
        return {}
    return {"label": _get_label(target),
            "item": _get_value(element(node, f"{xp}/{item}")),
            "text": text(node, f"{xp}/{item_text}")
        }

# -------------------
# ATTRIBUTE COLLECTION ITEMS
# -------------------

def _get_attribute_item(item: str) -> str:
    if item is None:
        return None
    return ITEMS_DICT.get(item, {}).get(_get_lang(), None) or f"Item not in cache: {item}"
