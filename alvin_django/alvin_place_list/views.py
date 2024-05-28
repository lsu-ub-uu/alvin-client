from django.shortcuts import render
from django.core.paginator import Paginator
import requests
from lxml import etree

# Create your views here.
def alvin_place_list(request):
    
    # List headers
    xml_headers_list = {'Content-Type':'application/vnd.uub.recordList+xml','Accept':'application/vnd.uub.recordList+xml'}

    # För previewmiljön
    preview_place_list_base_url = 'https://cora.epc.ub.uu.se/alvin/rest/record/searchResult/placeSearch?searchData={"name":"placeSearch","children":[{"name":"include","children":[{"name":"includePart","children":[{"name":"placeSearchTerm","value":"**"}]}]}]}'
    
    selected_country = request.GET.get('country', '')

    print(selected_country)
    if selected_country is None:
        selected_country = ''
        
    if selected_country:
        preview_place_list_base_url = preview_place_list_base_url.replace('**"', f'**"}},{{"name":"placeCountrySearchTerm","value":"{selected_country}"')

    print(preview_place_list_base_url)

    # För devmiljön
    # place_url = 'http://130.238.171.238:38081/alvin/rest/record/alvin-place'
    # record_url = 'http://130.238.171.238:38081/alvin/rest/record/test'

    
    response = requests.get(preview_place_list_base_url, headers=xml_headers_list)
    context = {}
    
    if response.status_code == 200:
        alvin_place_search_xml = etree.XML(response.content)

        paginated_metadata = [
                {"authority_names":list(zip(place.xpath("./authority/geographic/text()"), place.xpath("./authority/@lang"))),
                "variant_names":list(zip(place.xpath("./variant/geographic/text()"), place.xpath("./variant/@lang"))),
                "id":place.find("./recordInfo/id").text,
                } for place in alvin_place_search_xml.iter("place")
            ]
        
        countries = list(set(country.text for country in alvin_place_search_xml.xpath("//country")))

        paginator = Paginator(paginated_metadata, 1)
        
        page_number = request.GET.get('page')
        page_obj = paginator.get_page(page_number)

        metadata = {
            "fromNo":alvin_place_search_xml.xpath("//fromNo/text()"),
            "toNo":alvin_place_search_xml.xpath("//toNo/text()"),
            "totalNo":alvin_place_search_xml.xpath("//totalNo/text()"),
        }

        context = {
            "metadata":metadata,
            "xml":response.content,
            "page_obj":page_obj,
            "countries":countries
        }

    return render(request, "alvin_place_list/alvin_place_list.html", context)