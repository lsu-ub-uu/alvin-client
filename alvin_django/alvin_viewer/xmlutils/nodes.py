from lxml import etree
from typing import Iterable, Optional, List

def text(node: etree._Element, xpath: str, default: Optional[str] = None) -> Optional[str]:
    val = node.findtext(xpath)
    return val if val not in (None, "") else default

def texts(node: etree._Element, xpath: str) -> List[str]:
    return [n.findtext(".") for n in node.xpath(xpath)]

def attr(node: etree._Element, xpath_attr: str, default: Optional[str] = None) -> Optional[str]:
    # xpath_attr e.g. "./@type"
    if not xpath_attr.startswith("./@"):
        raise ValueError(f"attr() expects XPath like './@attrName' not {xpath_attr}")
    key = xpath_attr[3:]
    val = node.get(key)
    return val if val not in (None, "") else default

def element(node: etree._Element, xpath: str) -> etree._Element:
    return node.find(xpath) if node is not None else None

def elements(node: etree._Element, xpath: str) -> List[etree._Element]:
    return list(node.xpath(xpath))

def first(seq: Iterable):
    for x in seq:
        return x
    return None