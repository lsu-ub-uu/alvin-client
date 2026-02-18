from __future__ import annotations
from dataclasses import dataclass, fields
from importlib.metadata import metadata
from typing import Any, Dict, List, Optional, Union

from django.utils.translation import get_language
from django.urls import reverse

# ------------------
# COMMON
# ------------------

@dataclass(slots=True)
class Address:
    label: Optional[str] = None
    box: Optional[DecoratedText] = None
    street: Optional[str] = None
    postcode: Optional[str] = None
    place: Optional[OriginPlace] = None
    country: Optional[DecoratedListItem] = None

    def is_empty(self) -> bool:
        return not (self.label or self.box or self.street or self.postcode or self.place or self.country)

@dataclass(slots=True)
class Appraisal:
    label: Optional[str] = None
    value: Optional[str] = None
    currency: Optional[str] = None

    def is_empty(self) -> bool:
        return not(self.value or self.currency)
    
    @property
    def display(self) -> str:
        return " ".join(filter(None, ([self.value, self.currency])))
    
@dataclass
class Axis:
    label: Optional[str] = None
    clock: DecoratedListItem = None

    def is_empty(self) -> bool:
        return not self.clock.item

@dataclass(slots=True)
class Classification:
    label: Optional[str] = None
    type: Optional[str] = None
    text: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.text

@dataclass(slots=True)
class Coin:
    label: Optional[str]
    description: DecoratedText = None
    legend: DecoratedText = None
    
    @property
    def description_label(self):
        return f"{self.label}, {self.description.label}".capitalize()
    
    @property
    def legend_label(self):
        return f"{self.label}, {self.legend.label}".capitalize()

@dataclass(slots=True)
class CommonMetadata:
    id: str
    record_type: str
    created: Optional[DecoratedText] = None
    last_updated: Optional[DecoratedText] = None
    source_xml: Optional[str] = None

    @property
    def record_type_stripped(self) -> str:
        return self.record_type.replace("alvin-", "")

@dataclass
class Component:
    # Archives
    level: DecoratedListItem = None
    unitid: Optional[str] = None
    
    # Manuscripts
    languages: DecoratedList = None
    origin_places: OriginPlaceBlock = None
    physical_description_notes: DecoratedTextsWithType = None
    locus: DecoratedText = None
    incipit: DecoratedText = None
    explicit: DecoratedText = None
    rubric: DecoratedText = None
    final_rubric: DecoratedText = None
    literature: DecoratedText = None
    notes: DecoratedTextsWithType = None

    # Common
    title: TitlesBlock = None
    agents: List[Agent] = None
    place: RelatedAuthoritiesBlock = None
    related_records: RelatedRecordsBlock = None
    origin_date: DatesBlock = None
    extent: DecoratedText = None
    note: DecoratedText = None
    accession_numbers: DecoratedTexts = None
    electronic_locators: List[ElectronicLocator] = None
    access_policy: DecoratedText = None
    components: List[Component] = None

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

@dataclass(slots=True)
class Edge:
    label: Optional[str]
    item: Optional[str]
    text: Optional[str]

    def is_empty(self) -> bool:
        return not (self.item or self.text)
    
    @property
    def display(self) -> str:
        return ". ".join(filter(None, [self.item, self.text]))

@dataclass(slots=True)
class Dimension(Dict):
    label: Optional[str] = None
    scope: Optional[str] = None
    height: Optional[DecoratedText] = None
    width: Optional[DecoratedText] = None
    depth: Optional[DecoratedText] = None
    diameter: Optional[DecoratedText] = None
    unit: Optional[str] = None

    def is_empty(self) -> bool:
        return not (self.height or self.width or self.depth or self.diameter)

    @property
    def display(self) -> str:
        dimensions = [d for d in [self.height, self.width, self.depth, self.diameter] if d is not None]

        parts = []

        for d in dimensions:
            text, label = d.text, d.label
            joined = f"{text} ({label})"
            parts.append(str(joined))

        parts_str = " x ".join(filter(None,parts))
        unit_str = self.unit or None
        return " ".join(filter(None, (parts_str, unit_str))).lower()
    
    @property
    def combined_label(self):
        return f"{self.label}, {self.scope}".capitalize() if self.scope else self.label

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
class Measure:
    label: Optional[str] = None
    weight: Optional[str] = None
    unit: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.weight

    @property
    def display(self) -> Optional[str]:
        if self.weight:
            return f"{self.weight} {self.unit}" if self.unit else self.weight
        return None

@dataclass(slots=True)
class SubjectMiscEntry:
    label: Optional[str] = None
    authority: Optional[str] = None
    topic: Optional[str] = None
    genre_form: Optional[str] = None
    geographic_coverage: Optional[str] = None
    temporal: Optional[str] = None
    occupation: Optional[str] = None

    def is_empty(self) -> bool:
        return not (self.topic or self.genre_form or self.geographic_coverage or self.temporal or self.occupation)
    
    @property
    def display(self) -> str:
        parts = [p for p in [self.topic, self.genre_form, self.geographic_coverage, self.temporal, self.occupation] if p is not None]
        return ", ".join(filter(None, parts))

@dataclass(slots=True)
class SubjectMiscBlock:
    label: Optional[str] = None
    entries: List[SubjectMiscEntry] = None

    def is_empty(self) -> bool:
        return not self.entries
    
    @property
    def display(self) -> str:
        return " ; ".join(e.display for e in self.entries if e.display)


# ------------------
# NAMES AND TITLES BLOCKS 
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
# LINKED RECORDS
# ------------------

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
    record_type_field = "agent_type"
    roles: DecoratedList
    label: Optional[str] = None
    agent_type: Optional[str] = None
    id: Optional[str] = None
    names: NamesBlock = None
    certainty: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.names
    
    @property
    def display(self) -> str | None:
        title = self.names.title
        if self.certainty == "uncertain":
            title += "?"
        return title
    
    @property
    def display_roles(self) -> str | None:
        return ", ".join(self.roles.items) if self.roles.items else None

@dataclass(slots=True)
class Location(URL):
    fixed_record_type = "alvin-location"
    label: Optional[str] = None
    id: Optional[str] = None
    names: NamesBlock = None

    @property
    def display(self) -> Optional[str]:
        return self.names.title if self.names else None

@dataclass(slots=True)
class OriginPlace(URL):
    fixed_record_type = "alvin-place"
    label: Optional[str] = None
    id: Optional[str] = None
    name: NamesBlock = None
    country: DecoratedList = None
    historical_country: DecoratedList = None
    certainty: Optional[str] = None

    def is_empty(self) -> bool:
        return not self.name
    
    @property
    def display(self) -> Optional[str]:
        title = self.name.title
        if self.certainty == "uncertain":
            title += "?"
        return title
    
    @property
    def display_countries(self) -> Optional[str]:
        items = (self.country.items if self.country else []) + (self.historical_country.items if self.historical_country else [])
        return f", {', '.join(filter(None, (items)))}" if items else None
    
@dataclass(slots=True)
class OriginPlaceBlock:
    label: Optional[str] = None
    places: List[OriginPlace] = None

    def is_empty(self) -> bool:
        return not self.places
    
@dataclass(slots=True)
class RelatedAuthorityEntry(URL):
    id: Optional[str] = None
    record_type: Optional[str] = None
    type: Optional[str] = None
    label: Optional[str] = None
    name: List[Dict[str, Any]] = None

    def is_empty(self) -> bool:
        return not self.name
    
@dataclass
class RelatedAuthoritiesBlock:
    label: Optional[str] = None
    records: List[RelatedAuthorityEntry] = None

    def is_empty(self) -> bool:
        return not self.records
    
    def ordered_by_type(self) -> Dict[str, List[RelatedAuthorityEntry]] | None:
        records = getattr(self, "records", None)
        if records is None:
            return None
        
        ordered = {}
        for record in records:
            record_type = getattr(record, "type", None)
            if record_type not in ordered:
                ordered[record_type] = []
            ordered[record_type].append(record)

        return [RelatedAuthoritiesBlock(
            label=related_type,
            records = ordered_records
        ) for related_type, ordered_records in ordered.items()]
    
@dataclass
class RelatedRecordPart:
    type: Optional[str] = None
    typeattr: Optional[str] = None
    number: Optional[str] = None
    extent: Optional[str] = None

    @property
    def display(self) -> str:
        parts = [p for p in [self.number, self.extent] if p is not None]
        return ", ".join(filter(None, parts))

@dataclass 
class RelatedRecordEntry(URL):
    fixed_record_type = "alvin-record"
    type: Optional[str] = None
    id: Optional[str] = None
    main_title: TitlesBlock = None
    parts: List[RelatedRecordPart] = None

    @property
    def display_parts(self) -> str:
        if self.parts is None:
            return None
        return " ; ".join(filter(None, [f"{part.type}: {part.display}" for part in self.parts]))
    
@dataclass 
class RelatedRecordsBlock:
    label: Optional[str] = None
    records: List[RelatedRecordEntry] = None

    def is_empty(self) -> bool:
        return not self.records
    
    def ordered_by_type(self) -> Dict[str, List[RelatedRecordEntry]] | None:
        records = getattr(self, "records", None)
        if records is None:
            return None
        
        ordered = {}
        for record in records:
            record_type = getattr(record, "type", None)
            if record_type not in ordered:
                ordered[record_type] = []
            ordered[record_type].append(record)

        return [RelatedRecordsBlock(
            label=related_type,
            records = ordered_records
        ) for related_type, ordered_records in ordered.items()]

@dataclass(slots=True)
class RelatedWorkEntry(URL):
    fixed_record_type = "alvin-work"
    type: Optional[str] = None
    id: Optional[str] = None
    main_title: TitlesBlock = None

    def is_empty(self) -> bool:
        return not (self.type or self.id or self.main_title)

@dataclass 
class RelatedWorksBlock:
    label: Optional[str] = None
    records: List[RelatedRecordEntry] = None

# ------------------
# ALVIN-LOCATION SPECIFIC
# ------------------

@dataclass
class Summary:
    label: Optional[str] = None
    texts: List[Dict[str,str]] = None

    def is_empty(self) -> bool:
        return not self.texts

    @property
    def display(self):
        ui_lang = get_language()
        preferred = {'sv':'swe','en':'eng','no':'nor'}.get(ui_lang)

        if preferred in self.texts:
            return self.texts[preferred]
        
        first = next(iter(self.texts.values()), None)
        return first if first else ""
    
# ------------------
# BINARIES
# ------------------

@dataclass 
class File:
    type: Optional[str] = None
    binary_id: Optional[str] = None
    original_name: Optional[str] = None
    master_url: Optional[str] = None
    master_type: Optional[str] = None
    jp2_url: Optional[str] = None
    thumbnail_url: Optional[str] = None

@dataclass 
class FileGroup:
    type: Optional[str] = None
    files: List[File] = None

@dataclass 
class FilesBlock:
    rights: str = None
    digital_origin: str = None
    file_groups: List[FileGroup] = None