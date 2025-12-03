from django.shortcuts import render, get_object_or_404
from django.http import Http404
from django.utils.translation import get_language
from django.core.paginator import Paginator
import requests
from lxml import etree
from django.conf import settings

from alvin_viewer.views import get_dates
from alvin_viewer.templatetags import metadata_wrangler

from django.shortcuts import render
from django.http import HttpResponse

from django.utils.http import urlencode
from urllib.parse import quote

def members(request):
    return HttpResponse("Hello world!")

def get_authority_names(metadata, name_parts):

    # Extraherar auktoritetsnamn baserat på en angiven dict, name_parts, där nyckeln är ett metadatafält och värdet är en xpath.
    return {
        name.get("lang"): {
            key: name.findtext(xpath)
            for key, xpath in name_parts.items()
        }
        for name in metadata.xpath("./authority")
    }

def get_variant_names(metadata, name_parts):

    # Extraherar alternativa namn baserat på en angiven dict, name_parts, där nyckeln är ett metadatafält och värdet är en xpath.
    return [
        {
            key: name.findtext(xpath)
            for key, xpath in name_parts.items()
        }
        for name in metadata.xpath("./variant")
    ]

def paginator(request, paginated_metadata):
    
    paginator = Paginator(paginated_metadata, 20)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)

    return {
    "page_obj": page_obj,
    "page_number": page_number,
    }

def alvin_search(request):
    xml_headers_list = {'Content-Type':'application/vnd.cora.recordList-decorated+xml','Accept':'application/vnd.cora.recordList-decorated+xml'}

    searchType = request.GET.get('searchType', 'alvinRecord')
    query = request.GET.get('query', '**')        
    start = request.GET.get('start', 1)         
    rows = request.GET.get('rows', 20)
    startnum = int(start)
    rowsnum = int(rows)
    newstart = startnum + rowsnum
    newstartnum = int(newstart)
    

    list_url = f'https://cora.alvin-portal.org/rest/record/searchResult/{searchType}Search?searchData={{"name":"{searchType}Search","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"{searchType}SearchTerm","value":"{query}"}}]}}]}},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}'

    #list_url = f'{api_host}/rest/record/searchResult/{search_type}Search?searchData={{"name":"{search_type}Search","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"{search_type}SearchTerm","value":"{q}"}}]}}]}}]}}'

    response = requests.get(list_url, headers=xml_headers_list)
    
    if response.status_code == 200:
        xml_list = etree.fromstring(response.content)         
        records = []
        if searchType == 'alvinRecord':
            for record in xml_list.findall('data/record/data/record'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                     'datestamp': record.findtext('./recordInfo/updated/tsUpdated[last()]'),
         	     'setSpec': record.findtext('./physicalLocation/heldBy/location/linkedRecordId'),
                 })

        elif searchType == 'person':
            for record in xml_list.findall('data/record/data/person'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'namefamily': record.findtext('./authority[1]/name/namePart[@type = "family"]'),
                    'namegiven': record.findtext('./authority[1]/name/namePart[@type = "given"]'),
                    'namenumeration': record.findtext('./authority[1]/name/namePart[@type = "numeration"]'),
                    'nametermsOfAddress': record.findtext('./authority[1]/name/namePart[@type = "termsOfAddress"]'),
                    'familyName': record.findtext('./authority[1]/name/familyName'),
                    'birthyear': record.findtext('./personInfo/birthDate/date/year'),
                    'deathyear': record.findtext('./personInfo/deathDate/date/year'),
                    'displaydate': record.findtext('./personInfo/displayDate'),




                 })

        elif searchType == 'organisation':
            for record in xml_list.findall('data/record/data/organisation'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'nameone': record.findtext('./authority[1]/name/namePart[1]'),
                    'nametwo': record.findtext('./authority[2]/name/namePart[1]'),
                    'namethree': record.findtext('./authority[3]/name/namePart[1]'),
                    'subnameone': record.findtext('./authority[1]/name/namePart[2]'),
                    'subnametwo': record.findtext('./authority[2]/name/namePart[2]'),
                    'subnamethree': record.findtext('./authority[3]/name/namePart[2]'),
                 })

        elif searchType == 'place':
            for record in xml_list.findall('data/record/data/place'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'nameone': record.findtext('./authority[1]/geographic'),
                    'nametwo': record.findtext('./authority[2]/geographic'),
                    'namethree': record.findtext('./authority[3]/geographic'),
                 })

        pages = {
            "fromNo":xml_list.findtext(".//fromNo"),
            "toNo":xml_list.findtext(".//toNo"),
            "totalNo":xml_list.findtext(".//totalNo"),
            }
        totalNo = pages.get("totalNo")          
        completeListSize = int(totalNo)
        toNo = pages.get("toNo")          
        cursor = int(toNo) 
        if cursor < completeListSize: 
            startnum = int(start)
            rowsnum = int(rows)
            newstart = startnum + rowsnum
            nextstartnum = int(newstart)   

        if startnum > rowsnum:
            startnum = int(start)
            newstart = startnum + rowsnum
            nextstartnum = int(newstart)  
            rowsnum = int(rows)
            prevstart = startnum - rows
            prevstartnum = int(prevstart)   
  
    return render(request, 'alvin_search/alvin_search.html', locals())


def alvin_search_old(request, record_type):
    
    xml_headers_list = {'Content-Type':'application/vnd.cora.recordList+xml','Accept':'application/vnd.cora.recordList+xml'}
    
    # API host
    api_host = settings.API_HOST

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
    
    list_url = f'{api_host}/rest/record/searchResult/{search_type}Search?searchData={{"name":"{search_type}Search","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"{search_type}SearchTerm","value":"**"}}]}}]}}]}}'

    response = requests.get(list_url, headers=xml_headers_list)

    if response.status_code != 200:
        raise Http404("Record list not found")

    # Hantera XML
    list_xml = etree.fromstring(response.content)
    list_xml = etree.XML(response.content)

    metadata = {
            "fromNo":list_xml.findtext(".//fromNo"),
            "toNo":list_xml.findtext(".//toNo"),
            "totalNo":list_xml.findtext(".//totalNo"),
        }

    context = {
            "record_type": record_type,
            "xml": response.content,
            "metadata": metadata,
        }
    
    # Extrahera metadata
    if record_type == "alvin-work":
        context.update(extract_work_list_metadata(request, list_xml))
    elif record_type == "alvin-place":
        context.update(extract_place_list_metadata(request, list_xml))
    elif record_type == "alvin-organisation":
        context.update(extract_organisation_list_metadata(request, list_xml))
    elif record_type == "alvin-person":
        context.update(extract_person_list_metadata(request, list_xml))
    
    return render(request, 'alvin_search/alvin_search.html', context)
    
def extract_place_list_metadata(request, list_xml):    
    
    def get_authority_names(metadata):
        return {
            name.get("lang"): {
            "geographic": name.findtext("./geographic"),
        }
        for name in metadata.xpath("./authority")
    }
    
    def get_variant_names(metadata):
        return [
            {
            "geographic": name.findtext("./geographic"),
        }
        for name in metadata.xpath("./variant")]
    
    paginated_metadata = [
            {
            "authority_names": get_authority_names(place),
            "variant_names": get_variant_names(place),
            "id": place.findtext("./recordInfo/id"),
            } for place in list_xml.xpath("//data/place")
        ]

    return paginator(request, paginated_metadata)

def extract_person_list_metadata(request, list_xml):
    
    authority_name_parts = {
            "family_name": ".//name/namePart[@type='family']",
            "given_name": ".//name/namePart[@type='given']",
            "numeration": ".//name/namePart[@type='numeration']",
            "terms_of_address": ".//name/namePart[@type='termsOfAddress']",
            "orientation_code": ".//name/orientationCode",
            }
    
    variant_name_parts = {
            "family_name": ".//name/namePart[@type='family']",
            "given_name": ".//name/namePart[@type='given']",
            "numeration": ".//name/namePart[@type='numeration']",
            "terms_of_address": ".//name/namePart[@type='termsOfAddress']",
            "orientation_code": ".//name/orientationCode",
            "variant_type": "variantType",
            }

    paginated_metadata = [
            {
            "authority_names": get_authority_names(person, authority_name_parts),
            "variant_names": get_variant_names(person, variant_name_parts),
            "id": person.findtext("./recordInfo/id"),
            } for person in list_xml.xpath("//data/person")
        ]
        
    return paginator(request, paginated_metadata)

def extract_organisation_list_metadata(request, list_xml):
  
    authority_name_parts = {
            "corporate_name": "./name/namePart[@type='corporateName']",
            "subordinate_name": "./name/namePart[@type='subordinate']",
            "terms_of_address": "./name/namePart[@type='termsOfAddress']",
            "orientation_code": "./name/orientationCode",
            }
    
    variant_name_parts = {
            "corporate_name": "./name/namePart[@type='corporateName']",
            "subordinate_name": "./name/namePart[@type='subordinate']",
            "terms_of_address": "./name/namePart[@type='termsOfAddress']",
            "variant_type": "variantType",
            "orientation_code": "./name/orientationCode",
            }
    
    paginated_metadata = [
            {
            "authority_names": get_authority_names(organisation, authority_name_parts),
            "variant_names":  get_variant_names(organisation, variant_name_parts),
            "id": organisation.findtext("./recordInfo/id"),
            } for organisation in list_xml.xpath("//data/organisation")
        ]

    return paginator(request, paginated_metadata)

def extract_work_list_metadata(request, list_xml):

    def get_titles(title_type, metadata):
        return [{
                "main_title": title.findtext(f"./{title_type}/mainTitle"),
                "subtitle": title.findtext(f"./{title_type}/subtitle"),
                "orientation_code": title.findtext(f"./{title_type}/orientationCode"),
                } for title in metadata.xpath(".")
        ]

    paginated_metadata = [
            {
            "main_title": get_titles("title", work),
            "variant_titles": [get_titles(".", title) for title in work.xpath("./variantTitle")],
            "form_of_work": work.findtext("./formOfWork"),
            "id": work.findtext("./recordInfo/id"),
            } for work in list_xml.xpath("//data/work")
        ]

    return paginator(request, paginated_metadata)