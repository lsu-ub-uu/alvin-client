from __future__ import annotations
from dataclasses import dataclass
from typing import List, Optional

from .metadata import Address, Agent, Appraisal, Axis, Classification, Coin, CommonMetadata, Component, DateEntry, DatesBlock, DecoratedList, DecoratedListItem, Edge, DecoratedText, DecoratedTexts, DecoratedTextsWithType, Dimension, ElectronicLocator, FilesBlock, Identifier, Location, Measure, NamesBlock, OriginPlace, RelatedAuthoritiesBlock, RelatedRecordsBlock, SubjectMiscEntry, TitlesBlock

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
class AlvinLocation(CommonMetadata):
    label: Optional[str] = None
    authority_names: NamesBlock = None
    dates: DatesBlock = None
    display_date: DecoratedText = None
    member_type: DecoratedListItem = None
    email: DecoratedText = None
    summary: DecoratedTextsWithType = None
    address: Address = None
    latitude: DecoratedText = None
    longitude: DecoratedText = None
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

    @property
    def display_label(self):
        return f"{self.label}, {self.form_of_work.item}".capitalize

@dataclass(slots=True)
class AlvinRecord(CommonMetadata):
    label: Optional[str] = None
    type_of_resource: DecoratedListItem = None
    collection: DecoratedListItem = None
    production_method: DecoratedListItem = None
    main_title: TitlesBlock = None
    variant_titles: TitlesBlock = None
    agents: List[Agent] = None
    location: Location = None
    sublocation: DecoratedText = None
    shelf_mark: DecoratedText = None
    former_shelf_mark: DecoratedTexts = None
    subcollection: DecoratedList = None
    physical_location_note: DecoratedText = None
    edition_statement: DecoratedText = None
    origin_places: OriginPlace = None
    publications: DecoratedTexts = None
    origin_date: DatesBlock = None
    date_other: List[DatesBlock] = None
    languages: DecoratedList = None
    extent: DecoratedText = None
    dimensions: List[Dimension] = None
    measure: Measure = None
    base_material: DecoratedList = None
    applied_material: DecoratedList = None
    physical_description_notes: DecoratedTextsWithType = None
    summary: DecoratedText = None
    transcription: DecoratedText = None
    table_of_contents: DecoratedText = None
    literature: DecoratedText = None
    notes: DecoratedTextsWithType = None
    access_policy: DecoratedText = None
    related_records: RelatedRecordsBlock = None
    electronic_locators: List[ElectronicLocator] = None
    genre_form: DecoratedList = None
    subjects: List[SubjectMiscEntry] = None
    subject_person: RelatedAuthoritiesBlock = None
    subject_organisation: RelatedAuthoritiesBlock = None
    subject_place: RelatedAuthoritiesBlock = None
    classifications: List[Classification] = None
    deco_note: DecoratedText = None
    binding: DecoratedText = None
    binding_deco_note: DecoratedText = None
    identifiers: List[Identifier] = None
    work: RelatedAuthoritiesBlock = None
    components: List[Component] = None
    files: FilesBlock = None

    # Archives
    level: DecoratedListItem = None
    shelf_metres: DecoratedText = None
    archival_units: DecoratedText = None
    other_findaid: DecoratedTexts = None
    weeding: DecoratedTexts = None
    related_material: DecoratedTexts = None
    arrangement: DecoratedTexts = None
    accruals: DecoratedTexts = None

    # Manuscripts
    locus: DecoratedText = None
    incipit: DecoratedText = None
    explicit: DecoratedText = None
    rubric: DecoratedText = None
    final_rubric: DecoratedText = None

    # Musical notation
    music_key: DecoratedList = None
    music_key_other: DecoratedText = None
    music_medium: DecoratedList = None
    music_medium_other: DecoratedText = None
    music_notation: DecoratedList = None

    # Cartographic
    scale: DecoratedText = None
    projection: DecoratedText = None
    coordinates: DecoratedText = None

    #Numismatic
    appraisal: Appraisal = None
    axis: Axis = None
    edge: Edge = None
    conservation_state: DecoratedList = None
    obverse: Coin = None
    reverse: Coin = None
    countermark: DecoratedTexts = None