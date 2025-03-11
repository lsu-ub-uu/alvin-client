from django.shortcuts import render, get_object_or_404
from django.http import Http404
from django.utils.translation import get_language
from django.core.paginator import Paginator
import requests
from lxml import etree

from alvin_viewer.views import get_dates
from alvin_viewer.templatetags import metadata_wrangler

def alvin_list_viewer(request, record_type):
    
    xml_headers_list = {'Content-Type':'application/vnd.uub.recordList+xml','Accept':'application/vnd.uub.recordList+xml'}
    
    # API URLs
    api_urls = {
        'alvin-place': 'alvin-place/',
        'alvin-person': 'alvin-person/',
        'alvin-organisation': 'alvin-organisation/',
        'alvin-work': 'alvin-work/'
    }

    search_type = record_type.replace("alvin-","")

    if record_type not in api_urls:
        raise Http404("Invalid list type")
    
    list_url = f'https://cora.alvin-portal.org/rest/record/searchResult/{search_type}Search?searchData={{"name":"{search_type}Search","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"{search_type}SearchTerm","value":"**"}}]}}]}}]}}'

    response = requests.get(list_url, headers=xml_headers_list)

    if response.status_code != 200:
        raise Http404("Record list not found")

    # Hantera XML
    list_xml = etree.fromstring(response.content)
    list_xml = etree.XML(response.content)

    context = {
            "record_type": record_type,
            "xml": response.content,
        }
    
    metadata = {
            "fromNo":list_xml.findtext(".//fromNo"),
            "toNo":list_xml.findtext(".//toNo"),
            "totalNo":list_xml.findtext(".//totalNo"),
        }
    
    # Extrahera metadata
    if record_type == "alvin-work":
        
        def get_titles(title_type, metadata):
            return [{
                    "main_title": title.findtext(f"./{title_type}/mainTitle"),
                    "subtitle": title.findtext(f"./{title_type}/subtitle"),
                    "orientation_code": title.findtext(f"./{title_type}/orientationCode"),
                    } for title in metadata.xpath(".")
            ]
        
        paginated_metadata = [
                {
                "record_type": record_type,
                "main_title": get_titles("title", work),
                "variant_titles":[get_titles(".", title) for title in work.xpath("variantTitle")],
                "form_of_work": work.findtext("./formOfWork"),
                "id": work.findtext(".//recordInfo/id"),
                } for work in list_xml.xpath("//work")
            ]

        paginator = Paginator(paginated_metadata, 20)
        page_number = request.GET.get('page')
        page_obj = paginator.get_page(page_number)

        context.update({
        "metadata": metadata,
        "page_obj": page_obj,
        })

    elif record_type == "alvin-place":
        
        def get_names(name_type, metadata):
            return {
                name.get("lang"): {
                "geographic": name.findtext("./geographic"),
            }
            for name in metadata.xpath(f".")
        }
        
        paginated_metadata = [
                {
                "record_type": record_type,
                "authority_names": [get_names('.', name) for name in place.xpath(".//authority")],
                "variant_names": [get_names('.', name) for name in place.xpath(".//variant")],
                "id": place.findtext(".//recordInfo/id"),
                } for place in list_xml.xpath("//place")
            ]

        print(paginated_metadata)
        paginator = Paginator(paginated_metadata, 20)
        page_number = request.GET.get('page')
        page_obj = paginator.get_page(page_number)

        context.update({
        "metadata": metadata,
        "page_obj": page_obj,
        })

    return render(request, 'alvin_list_viewer/alvin_list_viewer.html', context)