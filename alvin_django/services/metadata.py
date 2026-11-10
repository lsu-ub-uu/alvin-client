from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional, Dict, List, Union
from django.utils.translation import get_language
from services.nodes import attr, element, elements, first, text, texts
from services.text_collector import get_item_dict

ITEMS_DICT = get_item_dict()

# ------------------
# NAMES AND TITLES BLOCKS 
# ------------------

@dataclass(slots=True)
class TitleEntry:
    label: Optional[str] = None
    type: Optional[str] = None
    main_title: Optional[str] = None
    subtitle: Optional[str] = None
    orientation_code: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.text
    
    @property
    def display(self) -> str:
        return " : ".join(filter(None, (self.main_title, self.subtitle)))

@dataclass(slots=True)
class TitlesBlock:
    label: Optional[str] = None
    titles: List[TitleEntry] = None

    def is_empty(self) -> bool:
        return not self.titles


@dataclass(slots=True)
class NameEntry:
    parts: Dict[str, str] = field(default_factory=dict)
    variant_type: Optional[str] = None
    label_lang: Optional[str] = None

    def get(self, key: str, default: str = "") -> str:
        return self.parts.get(key, default)

    @property
    def geographic(self) -> Optional[str]:
        return self.parts.get("geographic")

    @property
    def display_without_variant(self) -> str:
        if not self.parts:
            return ""
        if self.geographic:
            return self.geographic

        parts_keys = self.parts.keys()
        keys: List[str] = []
        joiner: str = " "

        if {"given_name", "family_name", "numeration"} & parts_keys:
            keys = ["given_name", "family_name", "numeration"]
            joiner = " "
        elif {"corporate_name", "subordinate_name"} & parts_keys:
            keys = ["corporate_name", "subordinate_name"]
            joiner = ": "

        n = joiner.join(filter(None, (self.parts.get(key) for key in keys)))
        
        terms = self.parts.get("terms_of_address")
        if terms:
            n = f"{n}, {terms}" if n else terms
            
        return n

    @property
    def display(self) -> str:
        n = self.display_without_variant
        if n and self.variant_type:
            return f"{n} ({self.variant_type})"
        return n


@dataclass(slots=True)
class NameValue:
    entries: List[NameEntry]

    @classmethod
    def from_any(cls, value: Union[NameEntry, List[NameEntry], None]) -> Optional[NameValue]:
        if value is None:
            return None
        if isinstance(value, list):
            return cls(entries=value)
        return cls(entries=[value])

    @property
    def label_lang(self) -> Optional[str]:
        return self.entries[0].label_lang if self.entries else None

    @property
    def display(self) -> str:
        return " ; ".join(e.display for e in self.entries if e.display)

    @property
    def display_without_variant(self) -> str:
        return " ; ".join(e.display_without_variant for e in self.entries if e.display_without_variant)

@dataclass(slots=True)
class NamesBlock:
    label: Optional[str] = None
    names: Dict[str, NameValue] | None = None

    def is_empty(self) -> bool:
        return not self.label and not self.names
    
    @property
    def title(self) -> str:
        if not self.names:
            return ""
        
        ui_lang = get_language()
        preferred = {'sv':'swe','en':'eng','no':'nor'}.get(ui_lang)

        if preferred in self.names:
            return self.names[preferred].display or ""

        for code in ("swe", "nor", "eng"):
            if code in self.names:
                return self.names[code].display or ""

        first = next(iter(self.names.values()), None)
        return first.display if first else ""

# ------------------
# DATES BLOCKS
# ------------------

@dataclass(slots=True)
class DateEntry:
    label: Optional[str] = None
    year: Optional[str] = None
    month: Optional[str] = None
    day: Optional[str] = None
    era: Optional[str] = None

    @property
    def display(self) -> str:
        if self.era:
            date_str += f" {self.era}"
        return date_str


@dataclass(slots=True)
class DatesValue:
    type: Optional[str] = None
    start_date: Optional[DateEntry] = None
    end_date: Optional[DateEntry] = None
    date_note: Optional[str] = None
    display_date: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.start_date and not self.end_date
    
    @property
    def display(self) -> str:
        if self.display_date:
            date_str = self.display_date
        else:
            start = self.start_date.display if self.start_date else None
            end = self.end_date.display if self.end_date else None
            date_str = " – ".join(s for s in (start, end) if s)
        if self.date_note:
            date_str += f":\n{self.date_note}"
        return date_str


@dataclass(slots=True)
class DatesBlock:
    label: Optional[str] = None
    type: Optional[str] = None
    dates: List[DatesValue] = None

    def is_empty(self) -> bool:
        return not self.dates

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
    return get_language()

def _get_target(node, xp):
    if node is None:
        return {}
    target = element(node, xp)
    return target

# ------------------
# NAMES AND TITLES EXTRACTOR FUNCTIONS
# ------------------


def names(node: etree._Element, xp: str, name_parts: Dict[str, str], variant_collection: str = None) -> NamesBlock | None:
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
        label_lang = _get_attribute_item("languageCodeCollection", attr(target, "./@lang")) or None
        
        variant_type = None
        if variant_collection:
            variant_type = _get_attribute_item(variant_collection, attr(target, "./@variantType"))

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

    block = NamesBlock(label=_get_label(element(node, xp)),
                       names=per_lang)
    if not block.label and not block.names:
        return None
    return block

def titles(root: etree._Element, xp: str) -> TitlesBlock:
    target = element(root, xp)
    if target is None:
        return None
    
    if "variantTitle" in xp:
        targets = elements(root, xp)

        return TitlesBlock(
            label = _get_label(target),
            titles = [TitleEntry(
                type = _get_attribute_item("variantTitleTypeCollection", attr(t, "./@variantType")),
                main_title = text(t, "mainTitle"),
                subtitle = text(t, "subtitle"),
                orientation_code = text(t, "orientationCode"),
            ) for t in targets]
        )

    return TitleEntry(
            label = _get_label(target),
            type = _get_attribute_item("variantTitleTypeCollection", attr(target, "./@variantType")),
            main_title = text(target, "mainTitle"),
            subtitle = text(target, "subtitle"),
            orientation_code = text(target, "orientationCode"),
        )

# -------------------
# DATES FUNCTIONS
# -------------------

def a_date(node: etree._Element, kind: str) -> DateEntry:
    target = _get_target(node, f"{kind}Date")
    if target is None:
        return None
    return DateEntry(
        label = _get_label(target),
        year = text(target, "date/year").lstrip("0"),
        month = text(target, "date/month"),
        day = text(target, "date/day"),
        era = _get_value(target, "date/era")
    )

def date(root: etree._ElementTree, xp: str, kind: str) -> DateEntry:
    target = _get_target(root, xp)
    if target is None:
        return None
    return a_date(target, kind)

def date_range(node: str, xp: str, start_tag: str, end_tag: str) -> DatesValue:
    target = element(node, xp)
    if target is None:
        return None
    return DatesValue(
        type = _get_attribute_item("dateTypeCollection", attr(target, "./@type")),
        start_date = a_date(target, f"{start_tag}"),
        end_date = a_date(target, f"{end_tag}"),
        date_note = text(target, "note"),
        display_date = text(target, "displayDate")
    )

def dates(node: etree._Element, xp: str, start_tag: str, end_tag: str) -> Dict:
    target = element(node, xp)
    if target is None:
        return None
    return DatesBlock(
        label = _get_label(target),
        type = _get_attribute_item("dateTypeCollection",attr(target, "./@type")),
        dates = DatesValue(
            type = _get_attribute_item("dateTypeCollection", attr(target, "./@type")),
            start_date = a_date(target, f"{start_tag}"),
            end_date = a_date(target, f"{end_tag}"),
            date_note = text(target, "note"),
            display_date = text(target, "displayDate")
        )
    )

# -------------------
# ATTRIBUTE COLLECTION ITEMS
# -------------------

def _get_attribute_item(collection: str, item: str) -> str:
    if item is None:
        return None
    try:
        return ITEMS_DICT.get(collection, {}).get(item, {}).get(_get_lang(), None) or f"Item not in cache: {item}"
    except Exception as e:
        return f"Error retrieving item: {item} ({str(e)})"
