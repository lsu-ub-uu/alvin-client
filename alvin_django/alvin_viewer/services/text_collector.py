import requests
from lxml import etree

_collection_variable_texts = [

]

def collect():
    
    xml_headers = {
    "Accept": "application/vnd.cora.recordList+xml"    
    }

    response = requests.get("https://cora.alvin-portal.org/rest/record/text/", headers=xml_headers)
    response.encoding = response.apparent_encoding
    r = response.content

    texts = etree.fromstring(r)
    data = texts.xpath("//data")

    print(len(data))
    
collect()