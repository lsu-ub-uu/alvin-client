# I extractors/place.py:
from dataclasses import dataclass, field
from typing import Optional, List
from services.metadata import NamesBlock, NameValue, NameEntry, names, _get_value
from services.mappings import place

@dataclass(slots=True, frozen=True)
class AlvinPlace:
    identifier: Optional[str] = None
    authority_names: NamesBlock = field(default_factory=NamesBlock)
    variants: List[NameEntry] = field(default_factory=list)
    country: Optional[str] = None

    @property
    def title(self) -> str:
        return ", ".join(filter(None, [self.authority_names.title, self.country]))

def extract_alvin_place(node) -> AlvinPlace:

    return AlvinPlace(
        identifier=node.findtext('./recordInfo/id'),
        authority_names = names(node, './authority', place["AUTH_NAME"]),
        variants = names(node, './variant',  place["VARIANT"], "variantplaceNameTypeCollection"),
        country=_get_value(node, './country'),
    )
