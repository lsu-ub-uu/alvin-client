from dataclasses import dataclass, field
from typing import List, Optional
from services.metadata import Agent, DatesBlock, DecoratedListItem, Location, NamesBlock, TitleEntry, agents, dates, decorated_list_item, location, names, titles


@dataclass(frozen=True)
class AlvinRecord:
    identifier: Optional[str] = None
    type_of_resource: Optional[str] = None
    collection: DecoratedListItem = None
    main_title: TitleEntry = field(default_factory=TitleEntry)
    agents: List[Agent] = None
    location: Location = field(default_factory=NamesBlock)
    origin_date: DatesBlock = field(default_factory=DatesBlock)
    collection: Optional[str] = None
    rights: Optional[str] = None
    file_count: int = 0
    file: Optional[str] = None

def extract_alvin_record(node) -> AlvinRecord:

    return AlvinRecord(
        identifier=node.findtext('./recordInfo/id'),
        type_of_resource = decorated_list_item(node, './typeOfResource'),
        collection = decorated_list_item(node, "./collection"),
        main_title=titles(node, './title'),
        agents = agents(node, "./agent"),
        location = location(node, "./physicalLocation/heldBy/location"),
        origin_date = dates(node, "./originDate", "start", "end"),
        rights=node.findtext('./fileSection/rights'),
        file_count=len(node.findall('./fileSection/fileGroup/file/fileLocation/linkedRecord')),
        file=node.findtext('./fileSection/fileGroup/file/fileLocation/linkedRecord/binary/thumbnail[1]/thumbnail/linkedRecordId'),
    )
