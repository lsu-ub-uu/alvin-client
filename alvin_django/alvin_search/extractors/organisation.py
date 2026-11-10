from dataclasses import dataclass, field
from typing import Optional, List
from services.metadata import NamesBlock, names
from services.mappings import organisation


@dataclass(slots=True, frozen=True)
class AlvinOrganisation:
    identifier: Optional[str] = None
    authority_names: NamesBlock = field(default_factory=NamesBlock)
    variants: NamesBlock = field(default_factory=NamesBlock)

    @property
    def title(self) -> str:
        return self.authority_names.title


def extract_alvin_organisation(node) -> AlvinOrganisation:
    authority_names = names(node, './authority', organisation["AUTH_NAME"])
    variants = names(node, './variant',  organisation["VARIANT"], "variantOrganisationNameTypeCollection")

    return AlvinOrganisation(
        identifier=node.findtext('./recordInfo/id'),
        authority_names=authority_names,
        variants=variants
    )
