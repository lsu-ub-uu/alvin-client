from django.shortcuts import render
import requests
from lxml import etree

# Create your views here.
def alvin_place_list(request):
    
    # List headers
    xml_headers_list = {'Content-Type':'application/vnd.uub.recordList+xml','Accept':'application/vnd.uub.recordList+xml','authToken':'ece65b5a-79f9-42a6-b0da-df1ee29eb308'}

    # För previewmiljön
    preview_place_list_url = 'https://cora.epc.ub.uu.se/alvin/rest/record/alvin-place/'

    # För devmiljön
    # place_url = 'http://130.238.171.238:38081/alvin/rest/record/alvin-place'
    # record_url = 'http://130.238.171.238:38081/alvin/rest/record/test'

    response_xml = requests.get(preview_place_list_url, headers=xml_headers_list)

    alvin_place_list_xml = etree.XML(response_xml.content)

    context = {
        "alvin_place_list":response_xml.content
    }

    return render(request, "alvin_place_list/alvin_place_list.html", context)