from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional, Dict, List, Union

from django.utils.translation import get_language
from django.urls import reverse

from services.mappings import person, place, organisation
from services.nodes import attr, element, elements, first, text, texts
from services.text_collector import get_item_dict

ITEMS_DICT = get_item_dict()

# -------------------
# DECORATED
# -------------------

@dataclass(slots=True)
class DecoratedText:
    label: Optional[str] = None
    parent_label: Optional[str] = None
    text: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.text
    
    @property
    def combined_label(self):
        return f"{self.parent_label}, {self.label}".capitalize() if self.parent_label is not None else self.label

@dataclass(slots=True)
class DecoratedTexts:
    label: Optional[str] = None
    texts: List[str] = None

    def is_empty(self) -> bool:
        return not self.texts
    
    @property
    def display(self) -> str:
        return ", ".join(self.texts) if self.texts else ""

@dataclass(slots=True)
class DecoratedTextWithType:
    type: Optional[str] = None
    text: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.text

@dataclass(slots=True)
class DecoratedTextsWithType:
    label: Optional[str] = None
    texts: List[DecoratedTextWithType] = None

    def is_empty(self) -> bool:
        return not self.texts

@dataclass(slots=True)
class DecoratedList:
    label: Optional[str] = None
    items: List[str] = None
    code: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.items
    
    @property
    def display(self) -> str:
        return ", ".join(self.items) if self.items else ""

@dataclass(slots=True)
class DecoratedListItem:
    label: Optional[str] = None
    item: Optional[str] = None
    code: Optional[str] = None

    def is_empty(self) -> bool:
        return not (self.label or self.item or self.code)

# -------------------
# LINKED DATA
# -------------------

@dataclass(slots=True)
class URL:
    record_type_field: str = "record_type"
    fixed_record_type: Optional[str] = None
    id_field: str = "id"

    @property
    def url(self) -> Optional[str]:
        id_ = getattr(self, self.id_field, None)
        if not id_:
            return None

        record_type = self.fixed_record_type or getattr(self, self.record_type_field, None)
        if not record_type:
            return None

        return reverse("alvin_viewer", args=[record_type, id_])


@dataclass(slots=True)
class Agent(URL):
    record_type_field: str = "agent_type"
    roles: Optional[DecoratedList] = None
    label: Optional[str] = None
    agent_type: Optional[str] = None
    id: Optional[str] = None
    names: Optional[NamesBlock] = None
    certainty: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.names
    
    @property
    def display(self) -> str | None:
        title = self.names.title if self.names else ""
        if self.certainty == "uncertain":
            title += "?"
        return title
    
    @property
    def display_roles(self) -> str | None:
        return ", ".join(self.roles.items) if self.roles and self.roles.items else None
    
    @property
    def icon_path(self) -> str | None:
        if self.agent_type == "alvin-person":
            return "../_icons/person.svg"
        return "../_icons/organisation.svg"


@dataclass(slots=True)
class Location(URL):
    fixed_record_type: str = "alvin-location"
    label: Optional[str] = None
    id: Optional[str] = None
    names: Optional[NamesBlock] = None

    @property
    def display(self) -> Optional[str]:
        return self.names.title if self.names else None


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
        date_str = "-".join(filter(None, (self.year, self.month, self.day)))
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
# DECORATED METADATA FUNCTIONS
# -------------------

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


def decorated_texts_with_type(node: etree.Element, xp: str, tag: str, typeCollection: str, textType: str | None = None) -> DecoratedTextsWithType | None:
    target = _get_target(node, xp)
    if target is None:
        return None
    
    dtwt = DecoratedTextsWithType(
        label = _get_label(target),
        texts = [DecoratedTextWithType(
            type = _get_attribute_item(typeCollection, attr(e, textType)),
            text = text(e, "."),
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

# -------------------
# LINKED DATA FUNCTIONS
# -------------------

def agents(node: etree._Element, xp: str) -> List[Agent]:
    target = element(node, xp)
    if target is None:
        return None
    
    agents = [Agent(
        label = _get_label(agent),
        agent_type = f"alvin-{attr(agent, './@type')}",
        id = text(agent, f"./{attr(agent, './@type')}/linkedRecordId"),
        names = names(agent, ".//authority", person["AUTH_NAME"] if attr(agent, './@type') == 'person' else organisation["AUTH_NAME"]),
        roles = decorated_list(agent, "role"),
        certainty = text(agent, "certainty"),
        ) for agent in elements(node, xp)]
    
    if all(a.is_empty() for a in agents):
        return None
    return agents


def location(node: etree._Element, xp: str) -> Location | None:
    if node is None:
        return None

    loc = element(node, xp)
    
    return Location(
        label = _get_label(loc),
        id = text(loc, "linkedRecordId"),
        names = names(loc, ".//authority", organisation["AUTH_NAME"]),
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
