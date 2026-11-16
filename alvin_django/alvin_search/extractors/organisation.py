from dataclasses import dataclass, field
from typing import Optional, List
from services.metadata import DatesValue, NamesBlock, names, date_range
from services.mappings import organisation


@dataclass(slots=True, frozen=True)
class AlvinOrganisation:
    identifier: Optional[str] = None
    authority_names: NamesBlock = field(default_factory=NamesBlock)
    variants: NamesBlock = field(default_factory=NamesBlock)
    organisation_info: DatesValue = field(default_factory=DatesValue)

    @property
    def title(self) -> str:
        return self.authority_names.title


def extract_alvin_organisation(node) -> AlvinOrganisation:
    identifier = node.findtext('./recordInfo/id')
    authority_names = names(node, './authority', organisation["AUTH_NAME"])
    variants = names(node, './variant',  organisation["VARIANT"], "variantOrganisationNameTypeCollection")
    organisation_info = date_range(node, './organisationInfo', 'start', 'end')

    return AlvinOrganisation(
        identifier=node.findtext('./recordInfo/id'),
        authority_names=authority_names,
        variants=variants,
        organisation_info = organisation_info
    )
