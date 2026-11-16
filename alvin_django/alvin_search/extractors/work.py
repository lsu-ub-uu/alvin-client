from dataclasses import dataclass, field
from typing import List, Optional
from services.metadata import Agent, DatesBlock, DecoratedListItem, TitleEntry, TitlesBlock, agents, dates, decorated_list_item, titles


@dataclass(frozen=True)
class AlvinWork:
    identifier: Optional[str] = None
    type_of_resource: DecoratedListItem = None
    form_of_work: DecoratedListItem = None
    main_title: TitleEntry = field(default_factory=TitleEntry)
    variant_titles: TitlesBlock = field(default_factory=TitlesBlock)

    agents: List[Agent] = None
    origin_date: DatesBlock = field(default_factory=DatesBlock)


def extract_alvin_work(node) -> AlvinWork:
    return AlvinWork(
        identifier = node.findtext('./recordInfo/id'),
        type_of_resource = decorated_list_item(node, "./typeOfResource"),
        form_of_work = decorated_list_item(node, "./formOfWork"),
        main_title=titles(node, './title'),
        variant_titles = titles(node, "./variantTitle"),
        agents = agents(node, "./agent"),
        origin_date = dates(node, "./originDate", "start", "end"),
    )
