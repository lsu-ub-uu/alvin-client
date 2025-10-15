from lxml import etree
from ..xmlutils.nodes import text, texts, attr, elements, first
from django.utils import translation
from ..xmlutils.nodes import text, texts, attr, elements
from ..extractors.common import authority_names
from ..extractors.person import AUTH_NAME as PERSON_AUTH_NAME
from ..extractors.organisation import AUTH_NAME as ORG_AUTH_NAME
from ..extractors.place import AUTH_NAME as PLACE_AUTH_NAME

BASE_XP = "data/record/"

def _get_lang():
    return translation.get_language()

def _get_value(element: etree._Element | None = None) -> str:
    if element is not None:
        return element.get(f"_value_{_get_lang()}")

def _get_label(element: etree._Element | None = None) -> str:
    if element is not None:
        return element.get(f"_{_get_lang()}")
    
def decorated_location(root: etree._Element, xp: str):

    loc = first(elements(root, f"{BASE_XP}{xp}"))
    names = {}
    
    for e in elements(loc, "linkedRecord/location/authority"):
        lang = attr(e, "./@lang")
        names[lang] = {key: text(e, xpath) for key, xpath in ORG_AUTH_NAME.items()}

    return {
        "label": _get_label(loc),
        "id": text(loc, "linkedRecordId"),
        "name": names,
        }

def decorated_agents(node: etree._Element, xp: str):

    agents = []
    
    for agent in elements(node, f"{BASE_XP}{xp}"):
        AN = PERSON_AUTH_NAME if attr(agent, './@type') == 'person' else ORG_AUTH_NAME
        agents.append({
            "label": _get_label(agent),
            "type": None if attr(agent, './@type') is None else f"alvin-{attr(agent, './@type')}",
            "id": text(agent, ".//linkedRecordId"),
            "name": authority_names(agent, AN),
            "role": [_get_value(e) for e in elements(agent, "role")],
            "certainty": text(agent, "certainty"),
        })

    return agents

def decorated_subject_authority(root: etree._Element, authority: str):
    
    AN = {
        "person": PERSON_AUTH_NAME,
        "organisation": ORG_AUTH_NAME,
        "place": PLACE_AUTH_NAME
    }
    
    label_element = root.find(f"{BASE_XP}subject[@type = '{authority}']")
    return {
        "label": _get_label(label_element),
        "authorities": [{
            "id": text(e, f"{authority}/linkedRecordId"),
            "name": authority_names(e, AN[authority]),
            } for e in elements(root, f"{BASE_XP}subject[@type = '{authority}']")]
        }

def decorated_text(root: etree.Element, xp: str) -> dict:
    return {
        "label": _get_label(root.find(f"{xp}")),
        "text": text(root, f"{xp}")
    }

def decorated_texts(root: etree.Element, xp: str | None = None) -> dict:
    return {
        "label": _get_label(root.find(f"{BASE_XP}{xp}")),
        "texts": texts(root, f"{BASE_XP}{xp}")
    }

def decorated_texts_with_type(root: etree.Element, xp: str, element: str, textType: str | None = None) -> dict:
    return {
        "label": _get_label(root.find(f"{BASE_XP}{xp}")),
        "texts": [{"type": attr(e, textType), "text": text(e, ".")} for e in elements(root, f"{BASE_XP}{xp}/{element}")]
    }

def decorated_list(node: etree._Element, xp: str) -> dict:
    return {
            "label": _get_label(node.find(f"{xp}")),
            "items": [_get_value(e) for e in elements(node, f"{xp}")],
            "code": text(node, f"{xp}")
    }