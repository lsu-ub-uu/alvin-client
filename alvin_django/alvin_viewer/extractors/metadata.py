from __future__ import annotations
from dataclasses import dataclass
from typing import Any, Dict, List, Optional, Union

from django.utils.translation import get_language
from django.urls import reverse

from .mappings import person, organisation

# ------------------
# COMMON AND HELPERS
# ------------------

@dataclass(slots=True)
class CommonMetadata:
    id: str
    record_type: str
    source_xml: str
    created: Optional[DecoratedText] = None
    last_updated: Optional[DecoratedText] = None
    source_xml: Optional[str] = None

@dataclass(slots=True, kw_only=True)
class DecoratedText:
    label: Optional[str] = None
    text: Optional[str] = None

    def is_empty(self) -> bool:
        return not (self.label or self.text)
    
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
class DecoratedTextsWithType:
    label: Optional[str] = None
    texts: List[Dict[str, str]] = None

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
        return not (self.label or self.items or self.code)

@dataclass(slots=True)
class ElectronicLocator:
    label: Optional[str] = None
    url: Optional[str] = None
    display_label: Optional[str] = None

    def is_empty(self) -> bool:
        return not (self.label or self.url or self.display_label)

@dataclass(slots=True)
class Identifier:
    label: Optional[str] = None
    type: Optional[str] = None
    identifier: Optional[str] = None

@dataclass(slots=True)
class RelatedAuthorityEntry:
    id: Optional[str] = None
    record_type: Optional[str] = None
    label: Optional[str] = None
    name: List[Dict[str, Any]] = None

    def is_empty(self) -> bool:
        return not (self.label or self.records)
    
    @property
    def url(self) -> Optional[str]:
        if self.id:
            return reverse("alvin_viewer", args=[f"alvin-{self.record_type}", self.id])
        return None
    
@dataclass
class RelatedAuthoritiesBlock:
    label: Optional[str] = None
    records: List[RelatedAuthorityEntry] = None

    def is_empty(self) -> bool:
        return not self.records

# ------------------
# NAMES BLOCKS 
# ------------------

@dataclass(slots=True)
class NameEntry:
    parts: Dict[str, str] = None
    variant_type: Optional[str] = None
    label_lang: Optional[str] = None

    def get(self, key: str, default: str = "") -> str:
        return self.parts.get(key, default)
    
    @property
    def geographic(self) -> str | None:
        return self.parts.get("geographic")
    
    @property
    def display(self) -> str | None:
        if self.geographic:
            return self.geographic
        

        for part in self.parts.keys():
            if part in ["given_name", "family_name", "numeration"]:
                keys = ["given_name", "family_name", "numeration"]
                joiner = " "
                break
            if part in ["corporate_name", "subordinate_name"]:
                keys = ["corporate_name", "subordinate_name"]
                joiner = ": "
                break

        n = joiner.join(filter(None, (self.parts.get(key) for key in keys)))
        if self.parts.get("terms_of_address"):
            n += f", {self.parts.get('terms_of_address')}"
        if self.parts.get("variant_type"):
            n += f" ({self.parts.get('variant_type')})"
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

NamesPerLang = Dict[str, Union[NameEntry, List[NameEntry]]]

@dataclass(slots=True)
class NamesBlock:
    label: Optional[str] = None
    names: Dict[str, NameValue] | None = None

    def is_empty(self) -> bool:
        return not self.label and not self.names
    
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
class DatesBlock:
    label: Optional[str] = None
    entries: List[DateEntry] = None

    def is_empty(self) -> bool:
        return not self.entries
    
# ------------------
# LINKED RECORDS
# ------------------

@dataclass(slots=True)
class OriginPlace:
    label: Optional[str] = None
    id: Optional[str] = None
    name: NamesBlock = None
    country: DecoratedList = None
    historical_country: DecoratedList = None
    certainty: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.places
    
    @property
    def display(self) -> str:
        title = self.name.title()
        if self.certainty == "uncertain":
            title += "?"
        return title
    
    @property
    def url(self) -> Optional[str]:
        if self.id:
            return reverse("alvin_viewer", args=["alvin-place", self.id])
        return None