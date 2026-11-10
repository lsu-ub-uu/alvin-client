from typing import List, Tuple, Callable, Dict, Any
from .record import extract_alvin_record
from .person import extract_alvin_person
from .organisation import extract_alvin_organisation
from .place import extract_alvin_place
from .work import extract_alvin_work

# Map searchType to XPath and extractor function
EXTRACTOR_REGISTRY: Dict[str, Tuple[str, Callable]] = {
    'alvinRecord': ('data/record/data/record', extract_alvin_record),
    'person': ('data/record/data/person', extract_alvin_person),
    'organisation': ('data/record/data/organisation', extract_alvin_organisation),
    'place': ('data/record/data/place', extract_alvin_place),
    'work': ('data/record/data/work', extract_alvin_work),
}

def extract_records_from_xml(search_type: str, xml_list) -> List[Any]:
    if search_type not in EXTRACTOR_REGISTRY:
        raise ValueError(f"Unsupported searchType: {search_type}")
    
    xpath, extractor_fn = EXTRACTOR_REGISTRY[search_type]
    return [extractor_fn(node) for node in xml_list.findall(xpath)]
