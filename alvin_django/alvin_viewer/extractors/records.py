from __future__ import annotations
from dataclasses import dataclass
from typing import List, Optional

from .metadata import CommonMetadata, DateEntry, DecoratedList, DecoratedListItem, DecoratedText, DecoratedTexts, DecoratedTextsWithType, ElectronicLocator, Identifier, NamesBlock, OriginPlace, RelatedAuthoritiesBlock

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
    start_date: DateEntry = None
    end_date: DateEntry = None
    display_date: DecoratedText = None
    notes: DecoratedTextsWithType = None
    identifiers: List[Identifier] = None
    address: dict = None
    electronic_locators: List[ElectronicLocator] = None
    related_organisations: RelatedAuthoritiesBlock = None