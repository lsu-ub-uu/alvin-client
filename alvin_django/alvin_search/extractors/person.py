from dataclasses import dataclass, field
from typing import Optional
from services.metadata import DatesValue, NamesBlock, names, date_range
from services.mappings import person
from ..metadata import DateRange


@dataclass(frozen=True)
class AlvinPerson:
    identifier: Optional[str] = None
    authority_names: NamesBlock = field(default_factory=NamesBlock)
    variants: NamesBlock = field(default_factory=NamesBlock)
    person_info: DatesValue = None

    @property
    def title(self) -> str:
        return self.authority_names.title

def extract_alvin_person(node) -> AlvinPerson:
    identifier = node.findtext('./recordInfo/id')
    authority_names = names(node, './authority', person["AUTH_NAME"])
    variants = names(node, './variant',  person["VARIANT"], "variantPersonNameTypeCollection")
    person_info = date_range(node, './personInfo', 'birth', 'death')

    return AlvinPerson(
        identifier=node.findtext('./recordInfo/id'),
        authority_names=authority_names,
        variants=variants,
        person_info = person_info

    )
