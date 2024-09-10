from django.shortcuts import render
from django.core.paginator import Paginator
import requests
from lxml import etree

# Create your views here.
def alvin_place_list(request):
    
    xml_headers_list = {'Content-Type':'application/vnd.uub.recordList+xml','Accept':'application/vnd.uub.recordList+xml'}

    # För previewmiljön
    pre_place_list_base_url = 'https://cora.alvin-portal.org/rest/record/searchResult/placeSearch?searchData={"name":"placeSearch","children":[{"name":"include","children":[{"name":"includePart","children":[{"name":"placeSearchTerm","value":"**"}]}]}]}'
    
    selected_country = request.GET.get('country', '')

    if selected_country:
        pre_place_list_base_url = pre_place_list_base_url.replace('**"', f'**"}},{{"name":"placeCountrySearchTerm","value":"{selected_country}"')
    
    response = requests.get(pre_place_list_base_url, headers=xml_headers_list)
    context = {}
    
    if response.status_code == 200:
        alvin_place_search_xml = etree.XML(response.content)

        paginated_metadata = [
                {"authority_names":list(zip(place.xpath("./authority/geographic/text()"))),
                "variant_names":list(zip(place.xpath("./variant/geographic/text()"), place.xpath("./variant/@lang"))),
                "id":place.find("./recordInfo/id").text,
                } for place in alvin_place_search_xml.iter("place")
            ]
        
        countries = list(set(country.text for country in alvin_place_search_xml.xpath("//country")))

        paginator = Paginator(paginated_metadata, 20)
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