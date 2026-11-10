from typing import Any, Dict, List, Callable, Optional, Union
from lxml import etree

from django.utils import translation
from django.core.cache import cache

from services.nodes import attr, element, elements, first, text, texts
from services.mappings import person, place, organisation
from services.metadata import _get_label, _get_value, _get_target, _get_attribute_item, dates, decorated_list, decorated_list_item, decorated_text, decorated_texts, decorated_texts_with_type, agents, names, titles, DecoratedTextWithType
from .metadata import (Address, Address, Component, ComponentsBlock, 
                       Edge, ElectronicLocator, Identifier,
                       OriginPlace, OriginPlaceBlock, RelatedAuthoritiesBlock,
                       RelatedAuthorityEntry, RelatedRecordsBlock, RelatedRecordEntry, 
                       RelatedRecordPart, RelatedWorksBlock, RelatedWorkEntry)


# ------------------
# DRY
# ------------------

# HELPERS ----------

def _xp(rt: str, xpath: str, absolute: bool = False) -> str:
    """
    Makes reuse of extractor functions possible between resource types.
    The absolute argument makes the xpath absolute if set to True.

    """
    return xpath if absolute else f"data/{rt}/{xpath}"

def _norm_rt(record_type: str) -> str:
    """
    Normalizes record type by cutting alvin- from string

    """
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


# COMMON -----------

def address(root: etree._Element, resource_type: str) -> Address:
    target = element(root, _xp(resource_type, ".//address"))
    if target is None:
        return None
    
    return Address(
        label = _get_label(element(root, _xp(resource_type, "address"))),
        box = text(root, _xp(resource_type, "address/postOfficeBox")),
        street = text(root, _xp(resource_type, "address/street")),
        postcode = text(root, _xp(resource_type, "address/postcode")),
        place = origin_place(root, _xp(resource_type, "address")),
        country = decorated_list_item(root, _xp(resource_type, "address/country"))
    )

def note_and_type(node: etree._Element, xp: str, note_type: str, type_collection: str) -> DecoratedTextWithType | None:
    target = _get_target(node, xp)
    if target is None:
        return None

    return DecoratedTextWithType(
        type = _get_attribute_item(note_type, type_collection),
        text = text(node, xp)
    )

def identifiers(root: etree._Element, xp: str) -> List[Identifier]:
    targets = elements(root, xp)
    if not targets:
        return None
    return [Identifier(
        label = _get_label(t),
        type = _get_attribute_item("identifierTypeCollection", attr(t, "./@type")), 
        identifier = text(t, ".")
    ) for t in targets]

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
            type = _get_attribute_item("relatedToTypeCollection", attr(t, "./@relatedToType")),
            id = text(t, f"record/linkedRecordId"),
            main_title = titles(t, f"record/linkedRecord/record/title"),
            parts = [RelatedRecordPart(
                type = _get_attribute_item("partTypeCollection", attr(part, "./@partType")),
                typeattr = attr(part, "./@partType"),
                number = text(part, "partNumber"),
                extent = text(part, "extent"),
                ) for part in elements(t, "part")],
            thumbnail_url = text(t, "record/linkedRecord/record/fileSection/fileGroup/file/fileLocation/linkedRecord/binary/thumbnail/thumbnail/actionLinks/read/url")
            ) for t in elements(node, xp)],
            
    )
    return rrb

def related_works(node: etree._Element, xp: str) -> List[Dict[str, str]] | None:
    target = _get_target(node, xp)
    if target is None:
        return None
    
    rws = RelatedWorksBlock(
        label = _get_label(target),
        records = [RelatedWorkEntry(
            type = _get_value(e, "linkedRecord/work/formOfWork"),
            id = text(e, "linkedRecordId"),
            main_title = titles(e, "linkedRecord/work/title"),
            ) for e in elements(node, xp)]
    )

    if all(rw.is_empty() for rw in rws.records):
        return None
    return rws

def related_authority(node: etree._Element, xp: str, authority: str, collection: str = None, alternative_label_xp: str = None) -> RelatedAuthoritiesBlock | None:
    target = element(node, xp)
    if target is None:
        return None
    
    related_type = _get_attribute_item(collection, attr(target, "./@type")) if collection else None

    AN = {
        "person": person["AUTH_NAME"],
        "organisation": organisation["AUTH_NAME"],
        "place": place["AUTH_NAME"]
    }
    
    label_node = element(node, alternative_label_xp) if alternative_label_xp else target

    related = RelatedAuthoritiesBlock(
        label = _get_label(label_node),
        records = [RelatedAuthorityEntry(
            id = text(e, f"{authority}/linkedRecordId"),
            type = related_type,
            record_type = text(e, (f"{authority}/linkedRecordType")),
            name = names(e, f"{authority}/linkedRecord/{authority}/authority", AN[authority]),
            )
            for e in elements(node, xp)]
    )
    
    if all(r.is_empty() for r in related.records):
        return None
    return related

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

def components(nodes: List[etree._Element]) -> ComponentsBlock | None:
    
    comps = []
    for comp in nodes:
        sub = components(comp.xpath("./*[contains(name(), 'component')]|./*[contains(name(), 'msItem')]")) or None
        md = Component(
            # Archives
            level = decorated_list_item(comp, "level"),
            unitid = decorated_text(comp, "unitid"),

            # Manuscripts
            languages = decorated_list(comp, "language"),
            origin_places = origin_places(comp, "originPlace"),
            physical_description_notes = decorated_texts_with_type(comp, "physicalLocation", "note", "noteTypeCollection", "./@noteType"),
            locus = decorated_text(comp, "locus"),
            incipit = decorated_text(comp, "incipit"),
            explicit = decorated_text(comp, "explicit"),
            rubric = decorated_text(comp, "rubric"),
            final_rubric = decorated_text(comp, "finalRubric"),
            literature = decorated_text(comp, "listBibl"),
            notes = decorated_texts_with_type(comp, "note", ".", "noteTypeCollection", "./@noteType"),

            # Common
            title = titles(comp, "title"),
            agents = agents(comp, "agent"),
            place =  related_authority(comp, ".", "place", "place", "place"),
            related_records = related_records(comp, "relatedTo"),
            origin_date = dates(comp, "originDate", "start", "end"),
            extent = decorated_text(comp, "extent"),
            note = decorated_text(comp, "note"),
            accession_numbers = decorated_texts(comp, "identifier[@type = 'accessionNumber']"),
            electronic_locators = electronic_locators(comp, "electronicLocator"),
            access_policy = decorated_text(comp, "accessPolicy"),
            components = sub
        )
        comps.append(md)
        
    return ComponentsBlock(items=comps) if comps else None

# ------------------
# DECORATED METADATA
# ------------------


def edge(node: etree._Element, xp: str, item: str, item_text: str) -> Edge:
    target = _get_target(node, xp)
    if target is None:
        return None
    
    li = Edge(
        label = _get_label(target),
        item = _get_value(element(node, f"{xp}/{item}")),
        text = text(node, f"{xp}/{item_text}")
    )

    if li.is_empty():
        return None
    return li