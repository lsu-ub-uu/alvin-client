from django.shortcuts import render
import requests
from lxml import etree

# Create your views here.
def alvin_place_list(request):
    
    # List headers
    xml_headers_list = {'Content-Type':'application/vnd.uub.recordList+xml','Accept':'application/vnd.uub.recordList+xml'}

    # För previewmiljön
    preview_place_list_url = 'https://cora.epc.ub.uu.se/alvin/rest/record/searchResult/placeSearch?searchData={"name":"placeSearch","children":[{"name":"include","children":[{"name":"includePart","children":[{"name":"placeSearchTerm","value":"**"}]}]}]}'

    # För devmiljön
    # place_url = 'http://130.238.171.238:38081/alvin/rest/record/alvin-place'
    # record_url = 'http://130.238.171.238:38081/alvin/rest/record/test'

    response = requests.get(preview_place_list_url, headers=xml_headers_list)

    alvin_place_search_xml = etree.XML(response.content)

    metadata = {
        "fromNo":alvin_place_search_xml.xpath("//fromNo/text()"),
        "toNo":alvin_place_search_xml.xpath("//toNo/text()"),
        "totalNo":alvin_place_search_xml.xpath("//totalNo/text()"),
        "places":{
            int(place.find("recordInfo/id").text):{
                "authority_names":place.xpath("./authority/geographic/text()"),
                "variant_names":list(zip(place.xpath("./variant/geographic/text()"), place.xpath("./variant/@lang"))),
            } for place in alvin_place_search_xml.iter("place")
        },
    }

    print(metadata['places'])

    context = {
        "metadata":metadata,
        "xml":response.content,
    }

    return render(request, "alvin_place_list/alvin_place_list.html", context)