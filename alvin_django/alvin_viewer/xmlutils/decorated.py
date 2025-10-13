from lxml import etree
from ..xmlutils.nodes import text, texts, attr, elements
from django.utils import translation
from ..xmlutils.nodes import text, texts, attr, elements
from ..extractors.common import authority_names
from ..extractors.person import AUTH_NAME as PERSON_AUTH_NAME
from ..extractors.organisation import AUTH_NAME as ORG_AUTH_NAME

BASE_XP = "data/record/"

def _get_value(element: etree._Element, lang: str | None = None) -> str:
    if element is not None:
        return element.get(f"_value_{lang}")

def _get_label(element: etree._Element, lang: str | None = None) -> str:
    if element is not None:
        return element.get(f"_{lang}")

def decorated_agents(node: etree._Element, xp: str):

    lang = translation.get_language()

    agents = []
    
    for agent in elements(node, f"{BASE_XP}{xp}"):
        an = PERSON_AUTH_NAME if attr(agent, './@type') == 'person' else ORG_AUTH_NAME
        agents.append({
            "label": _get_label(agent, lang),
            "type": f"alvin-{attr(agent, './@type')}",
            "id": text(agent, ".//linkedRecordId"),
            "name": authority_names(agent, an),
            "role": [_get_value(e, lang) for e in elements(agent, "role")],
            "certainty": agent.findtext("certainty"),
        })

    return agents


def decorated_text(root: etree.Element, xp: str | None = None) -> dict:
    return {
        "label": _get_label(root.find(f"{BASE_XP}{xp}"), translation.get_language()),
        "text": text(root, f"{BASE_XP}{xp}")
    }

def decorated_texts(root: etree.Element, xp: str | None = None) -> dict:
    return {
        "label": _get_label(root.find(f"{BASE_XP}{xp}"), translation.get_language()),
        "texts": texts(root, f"{BASE_XP}{xp}")
    }

def decorated_texts_with_type(root: etree.Element, xp: str, element: str, textType: str | None = None) -> dict:
    return {
        "label": _get_label(root.find(f"{BASE_XP}{xp}"), translation.get_language()),
        "texts": [{"type": attr(e, textType), "text": text(e, ".")} for e in elements(root, f"{BASE_XP}{xp}/{element}")]
    }

def decorated_list(root: etree._Element, xp: str) -> dict:
    
    lang = translation.get_language()
    
    return {
            "label": _get_label(root.find(f"{BASE_XP}{xp}"), lang),
            "items": [_get_value(e, lang) for e in elements(root, f"{BASE_XP}{xp}")],
            "code": text(root, f"{BASE_XP}{xp}")
            } or None

_subjects_misc_texts = {
    "attributes": [
        "./@authority"
    ],
    "texts": {
        "topic": "topic",
        "genreForm": "genreForm",
        "geographicCoverage": "geographicCoverage",
        "temporal": "temporal",
        "occupation": "occupation"
    }
}