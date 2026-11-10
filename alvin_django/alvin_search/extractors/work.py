from dataclasses import dataclass, field
from typing import Optional
from services.metadata import TitleEntry


@dataclass(frozen=True)
class AlvinWork:
    identifier: Optional[str] = None
    title_info: TitleEntry = field(default_factory=TitleEntry)

    @property
    def title(self) -> Optional[str]: return self.title_info.main_title
    @property
    def subtitle(self) -> Optional[str]: return self.title_info.subtitle
    @property
    def orientationCode(self) -> Optional[str]: return self.title_info.orientation_code


def extract_alvin_work(node) -> AlvinWork:
    return AlvinWork(
        identifier=node.findtext('./recordInfo/id'),
        title_info=TitleEntry(
            main_title=node.findtext('./title/mainTitle'),
            subtitle=node.findtext('./title/subtitle'),
            orientation_code=node.findtext('./title/orientationCode'),
        ),
    )
