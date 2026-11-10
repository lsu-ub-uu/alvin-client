from dataclasses import dataclass, field
from typing import Optional
from services.metadata import NamesBlock, TitleEntry, names, titles
from ..metadata import DateRange, HeldByLocation


@dataclass(frozen=True)
class AlvinRecord:
    identifier: Optional[str] = None
    main_title: TitleEntry = field(default_factory=TitleEntry)
    agents: NamesBlock = field(default_factory=NamesBlock)
    location_info: HeldByLocation = field(default_factory=HeldByLocation)
    origin_date: DateRange = field(default_factory=DateRange)
    typeofresource: Optional[str] = None
    collection: Optional[str] = None
    rights: Optional[str] = None
    file_count: int = 0
    file: Optional[str] = None

    # --- Bakåtkompatibla properties för Django-templates ---
    @property
    def title(self) -> Optional[str]: return self.main_title
    @property
    def subtitle(self) -> Optional[str]: return self.main_title.subtitle
    @property
    def orientationCode(self) -> Optional[str]: return self.main_title.orientation_code
    @property
    def namefamily(self) -> Optional[str]: return self.primary_agent.family
    @property
    def namegiven(self) -> Optional[str]: return self.primary_agent.given
    @property
    def namenumeration(self) -> Optional[str]: return self.primary_agent.numeration
    @property
    def nametermsOfAddress(self) -> Optional[str]: return self.primary_agent.terms_of_address
    @property
    def familyName(self) -> Optional[str]: return self.primary_agent.family_name_flag
    @property
    def namefamilytwo(self) -> Optional[str]: return self.secondary_agent_family
    @property
    def locationsv(self) -> Optional[str]: return self.location_info.sv
    @property
    def locationen(self) -> Optional[str]: return self.location_info.en
    @property
    def locationno(self) -> Optional[str]: return self.location_info.no
    @property
    def shelfmark(self) -> Optional[str]: return self.location_info.shelfmark
    @property
    def yearone(self) -> Optional[str]: return self.origin_date.start_year
    @property
    def yeartwo(self) -> Optional[str]: return self.origin_date.end_year
    @property
    def displaydate(self) -> Optional[str]: return self.origin_date.display_date


def extract_alvin_record(node) -> AlvinRecord:
    # Hämta sub-noder EN gång istället för att traversera från roten varje gång
    loc_node = node.find('./physicalLocation')
    origin_node = node.find('./originDate')

    return AlvinRecord(
        identifier=node.findtext('./recordInfo/id'),
        main_title=titles(node, './title'),
        agents = None,
        location_info=HeldByLocation(
            sv=loc_node.findtext('heldBy/location/linkedRecord/location/authority[@lang = "swe"]/name/namePart') if loc_node is not None else None,
            en=loc_node.findtext('heldBy/location/linkedRecord/location/authority[@lang = "eng"]/name/namePart') if loc_node is not None else None,
            no=loc_node.findtext('heldBy/location/linkedRecord/location/authority[@lang = "nor"]/name/namePart') if loc_node is not None else None,
            shelfmark=loc_node.findtext('shelfMark') if loc_node is not None else None,
        ),
        origin_date=DateRange(
            start_year=origin_node.findtext('startDate/date/year') if origin_node is not None else None,
            end_year=origin_node.findtext('endDate/date/year') if origin_node is not None else None,
            display_date=origin_node.findtext('displayDate') if origin_node is not None else None,
        ),
        typeofresource=node.findtext('./typeOfResource'),
        collection=node.findtext('./collection'),
        rights=node.findtext('./fileSection/rights'),
        file_count=len(node.findall('./fileSection/fileGroup/file/fileLocation/linkedRecord')),
        file=node.findtext('./fileSection/fileGroup/file/fileLocation/linkedRecord/binary/thumbnail[1]/thumbnail/linkedRecordId'),
    )
