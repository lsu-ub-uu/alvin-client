from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
import requests
from lxml import etree
parser = etree.XMLParser()
import base64
import json
import datetime
from django.http import HttpResponse
from django.utils.encoding import force_bytes, force_str

def urn(request):
  xml_headers_list = {'Content-Type':'application/vnd.cora.recordList+xml','Accept':'application/vnd.cora.recordList+xml'}
   
  start = request.GET.get('start', 1)

  rows = request.GET.get('rows', 1000)
  
  search = '**'
  
  list_url = f'https://cora.alvin-portal.org/rest/record/searchResult/alvinRecordSearch?searchData={{"name":"alvinRecordSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"alvinRecordSearchTerm","value":"{search}"}}]}}]}},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}'
  response = requests.get(list_url, headers=xml_headers_list)

  if response.status_code != 200:
        raise Http404("Record list not found")

  # Parse the XML file
  xml_list = etree.fromstring(response.content)

  headers = []

  # Convert XML data to a list of dictionaries
  records = []
  for record in xml_list.findall('data/record/data/record'):
      records.append({
         'id': record.findtext('./recordInfo/id', default='N/A'),
         'urn': record.findtext('./recordInfo/urn', default='N/A'),
	 'base': 'https://www.alvin-portal.org/alvin-record/'
       })

  # Pass the data to the template
  return render(request, 'urn.xml', {'records': records}, content_type='text/xml')

def oai(request):
  xml_headers_list = {'Content-Type':'application/vnd.cora.record-decorated+xml','Accept':'application/vnd.cora.record-decorated+xml'}

  list_url = f'https://cora.alvin-portal.org/rest/record/metadata/metadataFormatCollection'
  response = requests.get(list_url, headers=xml_headers_list)

  if response.status_code != 200:
        raise Http404("Record list not found")

  # Parse the XML file
  xml_list = etree.fromstring(response.content)

  # Convert XML data to a list of dictionaries
  metadataformats = []
  for metadataformat in xml_list.findall('./data/metadata/collectionItemReferences/ref'):
      metadataformats.append({
         'prefix': metadataformat .findtext('./linkedRecord/metadata/nameInData', default='N/A'),
         'namespace': metadataformat .findtext('./linkedRecord/metadata/textId/linkedRecord/text/textPart[1]/text', default='N/A'),
	 'schema': metadataformat .findtext('./linkedRecord/metadata/defTextId/linkedRecord/text/textPart[1]/text', default='N/A'),
       })
 
  # Pass the data to the template
  return render(request, 'oai_dc.xml', {'metadataformats': metadataformats}, content_type='text/xml')

def generate_resumption_token(cursor, page_size, total_records, metadataPrefix, set):
    state = f"cursor={cursor}:{page_size}:{total_records}:metadataPrefix={metadataPrefix}:set={set}"
    token_bytes = state.encode("utf-8")
    return base64.urlsafe_b64encode(token_bytes).decode("utf-8")

def decode_token(token: str) -> dict:
    try:
        json_str = base64.urlsafe_b64decode(token.encode()).decode()
        return json.loads(json_str)
    except Exception:
        return {}

def xml_feed(request):

    params = request.POST.copy() if request.method == "POST" else request.GET.copy()

    cursor = 2 
    page_size = 10
    total_records = 177777
    metadataPrefix = 'oai_dc'
    set = 3
    start = 1

    if cursor + page_size < total_records:
        token_value = generate_resumption_token(cursor, page_size, total_records, metadataPrefix, set)

    if "resumptionToken" in params:

        token = request.GET.get("resumptionToken")
    
        if token:
            state = decode_token(token)
            cursor = state.get("cursor")
            page_size = state.get("page_size")
            total_records = '233'
            metadataPrefix = state.get("metadataPrefix")
            set = state.get("set")

        else:
           state = 0


    return render(request, 'oai_rt.xml', {'token_value':token_value, 'cursor':cursor, 'page_size':page_size, 'total_records':total_records, 'set':set, 'metadataPrefix': metadataPrefix}, content_type='text/xml')




 
    
    
