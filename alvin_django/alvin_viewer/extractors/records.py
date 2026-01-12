from __future__ import annotations
from dataclasses import dataclass
from typing import List, Optional

from .metadata import Address, Agent, CommonMetadata, DateEntry, DatesBlock, DecoratedList, DecoratedListItem, DecoratedText, DecoratedTexts, DecoratedTextsWithType, ElectronicLocator, Identifier, NamesBlock, OriginPlace, RelatedAuthoritiesBlock, TitlesBlock

@dataclass(slots=True)
class AlvinPlace(CommonMetadata):
    label: Optional[str] = None
    authority_names: NamesBlock = None
    variant_names: NamesBlock = None
    country: Optional[DecoratedListItem] = None
    latitude: Optional[DecoratedText] = None
    longitude: Optional[DecoratedText] = None

@dataclass(slots=True)
class AlvinPerson(CommonMetadata):
    label: Optional[str] = None
    authority_names: NamesBlock = None
    variant_names: NamesBlock = None
    birth_date: DateEntry = None
    death_date: DateEntry = None
    display_date: DecoratedText = None
    birth_place: OriginPlace = None
    death_place: OriginPlace = None
    nationality: DecoratedList = None
    gender: DecoratedListItem = None
    fields_of_endeavor: DecoratedTexts = None
    notes: DecoratedTextsWithType = None
    identifiers: List[Identifier] = None
    electronic_locators: List[ElectronicLocator] = None
    related_persons: RelatedAuthoritiesBlock = None
    related_organisations: RelatedAuthoritiesBlock = None

@dataclass(slots=True)
class AlvinOrganisation(CommonMetadata):
    label: Optional[str] = None
    authority_names: NamesBlock = None
    variant_names: NamesBlock = None
    organisation_info: DatesBlock = None
    display_date: DecoratedText = None
    notes: DecoratedTextsWithType = None
    identifiers: List[Identifier] = None
    address: Address = None
    electronic_locators: List[ElectronicLocator] = None
    related_organisations: RelatedAuthoritiesBlock = None

@dataclass(slots=True)
class AlvinWork(CommonMetadata):
    label: Optional[str] = None
    form_of_work: DecoratedListItem = None
    main_title: TitlesBlock = None
    variant_titles: TitlesBlock = None
    origin_date: DatesBlock = None
    origin_places: OriginPlace = None
    date_other: List[DatesBlock] = None
    incipit: DecoratedText = None
    literature: DecoratedText = None
    note: DecoratedText = None
    agents: List[Agent] = None
    longitude: DecoratedText = None
    latitude: DecoratedText = None
    electronic_locators: List[ElectronicLocator] = None
    music_key: DecoratedList = None
    music_key_other: DecoratedText = None
    music_medium: DecoratedList = None
    music_medium_other: DecoratedText = None
    genre_form: DecoratedList = None
    serial_number: DecoratedText = None
    opus_number: DecoratedText = None
    thematic_number: DecoratedText = None

@dataclass(slots=True)
class AlvinRecord(CommonMetadata):
    label: Optional[str] = None
    type_of_resource: DecoratedListItem = None
    collection: DecoratedListItem = None
    production_method: DecoratedListItem = None
    main_title: TitlesBlock = None
    variant_titles: TitlesBlock = None
    origin_date: DatesBlock = None
    origin_places: OriginPlace = None
    date_other: List[DatesBlock] = None
    incipit: DecoratedText = None
    literature: DecoratedText = None
    note: DecoratedText = None
    agents: List[Agent] = None
    longitude: DecoratedText = None
    latitude: DecoratedText = None
    electronic_locators: List[ElectronicLocator] = None
    music_key: DecoratedList = None
    music_key_other: DecoratedText = None
    music_medium: DecoratedList = None
    music_medium_other: DecoratedText = None
    genre_form: DecoratedList = None
    serial_number: DecoratedText = None
    opus_number: DecoratedText = None
    thematic_number: DecoratedText = None