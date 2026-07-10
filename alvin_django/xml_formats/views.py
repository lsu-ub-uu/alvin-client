# Custom resolver to allow only specific external URLs
from django.conf import settings
from django.shortcuts import render, get_object_or_404
from django.http import Http404
from lxml import etree
from django.urls import reverse
from django.utils.http import urlencode
from urllib.parse import quote

from django.utils.http import urlsafe_base64_encode
from django.utils.http import urlsafe_base64_decode
from django.utils.encoding import force_bytes
from django.utils.encoding import force_str

import base64
import json

api_host = settings.API_HOST

class SafeHTTPResolver(etree.Resolver):
    def resolve(self, url, pubid, context):
        # Allow only HTTP/HTTPS URLs from trusted domains
        if url.startswith("http://") or url.startswith("https://"):
            # Example: restrict to example.com
            if api_host not in url:
                raise ValueError(f"Blocked external URL: {url}")
            
            # Fetch the content
            resp = requests.get(url, timeout=5)
            resp.raise_for_status()
            return self.resolve_string(resp.text, context)
        
        # Fallback to default resolution
        return None

from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
from django.templatetags.static import static
import requests

parser = etree.XMLParser()
parser.resolvers.add(SafeHTTPResolver())
import urllib.request
from urllib.request import urlopen

def urn(request):
  xml_headers_list = {'Content-Type':'application/vnd.cora.recordList+xml','Accept':'application/vnd.cora.recordList+xml'}
  start = request.GET.get('start', 1)
  rows = request.GET.get('rows', 1000)  
  search = '**'
  root = request.build_absolute_uri('/')
  
  list_url = f'{api_host}/rest/record/searchResult/alvinRecordSearch?searchData={{"name":"alvinRecordSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"alvinRecordSearchTerm","value":"{search}"}}]}}]}},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}'
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
	 'base': root + 'alvin-record/'
       })

  if response.status_code != 200:
        raise Http404("Record list not found")
  
# Pass the data to the template
  return render(request, 'xml_formats/urn.xml', {'records': records}, content_type='text/xml')

def alvinrecordschema(request):
  return render (request, 'xml_formats/alvin-record-schema.xml', content_type='text/xml')

def metadatardf(request, id):
  api_host = settings.API_HOST
  base_url = api_host + '/rest/record/metadata/'
  url = base_url + id
  req = urllib.request.Request(url)
  req.add_header('Accept', 'application/vnd.cora.record-decorated+xml')
  xslt_path = static('xsl/metadata-rdf.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)
  domain_root = request.build_absolute_uri('/')[:-1] 

  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  argDict["domain_root"] = etree.XSLT.strparam(domain_root)

  with urllib.request.urlopen(req) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
  metadatardf = transform(xml_tree, **argDict)	# Transform source XML tree
    
  return render (request, 'xml_formats/metadata-rdf.xml', {'metadatardf': metadatardf}, content_type='application/rdf+xml')

def record_viewer(request, record_type, record_id):
  format = request.GET.get('format', 'xml')
  baseurl = api_host + '/rest/record/'
  url = baseurl + record_type + '/' + record_id
  xslt_path_xml = static('xsl/record-xml.xsl')
  absolute_xslt_xml = request.build_absolute_uri(xslt_path_xml)
  xslt_path_rdf = static('xsl/record-rdf.xsl')
  absolute_xslt_rdf = request.build_absolute_uri(xslt_path_rdf)
  xslt_path_json = static('xsl/record-json.xsl')
  absolute_xslt_json = request.build_absolute_uri(xslt_path_json)
  host_url = reverse('record_viewer', kwargs={'record_type': record_type, 'record_id': record_id})
  relative_url = f"{host_url}?format={format}"
  domain_root = request.build_absolute_uri(relative_url)
  
  argDict = {}
  argDict["domain_root"] = etree.XSLT.strparam(domain_root)

  req = urllib.request.Request(url)
  if format == 'xml':
    req.add_header('Accept', 'application/vnd.cora.record+xml') 
  elif format == 'json':
    req.add_header('Accept', 'application/vnd.cora.record-decorated+xml') 
  elif format == 'rdf':
    req.add_header('Accept', 'application/vnd.cora.record-decorated+xml')  

  response = requests.get(url)
  
  if response.status_code != 200:
    raise Http404("Record not found")
                  
  with urllib.request.urlopen(req) as f:
    xml_tree = etree.parse(f, parser)

    if format == 'rdf':

      with urlopen(absolute_xslt_rdf) as f:
        xslt_tree = etree.parse(f, parser)
        transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
        recordxml = transform(xml_tree, **argDict)	# Transform source XML tree

    elif format == 'xml':

      with urlopen(absolute_xslt_xml) as f:
        xslt_tree = etree.parse(f, parser)
        transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
        recordxml = transform(xml_tree, **argDict)	# Transform source XML tree

    elif format == 'json':

      with urlopen(absolute_xslt_json) as f:
        xslt_tree = etree.parse(f, parser)
        transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
        recordjson = transform(xml_tree, **argDict)	# Transform source XML tree
                           
    else:
      raise Http404("Format not found")

  if format == 'json':
    #response render (request, 'xml_formats/recordjson.json', {'recordjson': recordjson})
    response = render(request, 'xml_formats/recordjson.json', {'recordjson': recordjson})

  # 2. Add or modify headers using the .headers dictionary
    response.headers['Content-Type'] = 'application/ld+json'  # Standard server response type
    response.headers['Accept'] = 'application/ld+json;profile="https://linked.art/ns/v1/linked-art.json"' # Any custom tracking header
    
  # 3. Return the modified response object
    return response

  elif format == 'rdf':
    return render (request, 'xml_formats/recordxml.xml', {'recordxml': recordxml}, content_type='application/rdf+xml')

  else:
    return render (request, 'xml_formats/recordxml.xml', {'recordxml': recordxml}, content_type='text/xml')

def alvinvocabulary(request):
  xml_path = static('xml/rdf_properties.xml')
  absolute_xml = request.build_absolute_uri(xml_path)
  xslt_path = static('xsl/alvin_vocabulary.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)
  #full_url = request.build_absolute_uri()
  full_url = 'https://www.alvin-portal.org/alvin/onthology'
  #domain_root = request.build_absolute_uri('/')[:-1] 
  domain_root = 'https://www.alvin-portal.org/alvin'
  
  argDict = {}
  argDict["full_url"] = etree.XSLT.strparam(full_url)
  argDict["domain_root"] = etree.XSLT.strparam(domain_root)

  with urllib.request.urlopen(absolute_xml) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
  alvinvocabulary = transform(xml_tree, **argDict)	# Transform source XML tree

  return render (request, 'xml_formats/alvinvocabulary.xml', {'alvinvocabulary': alvinvocabulary}, content_type='text/xml')

def alvinrdf(request):
  return render (request, 'xml_formats/alvin-rdf.xml', content_type='application/rdf+xml')

def onthologyrdf(request, id):
  id = id
  xml_path = reverse('alvinrdf')
  absolute_xml = request.build_absolute_uri(xml_path)
  xslt_path = static('xsl/onthology-rdf.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)
  full_url = request.build_absolute_uri()
  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["id"] = etree.XSLT.strparam(id)
  
  with urllib.request.urlopen(absolute_xml) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
  onthologyrdf = transform(xml_tree, **argDict)	# Transform source XML tree

  return render (request, 'xml_formats/onthology-rdf.xml', {'onthologyrdf': onthologyrdf, 'id': id}, content_type='application/rdf+xml')

def linked_art_search_json(request, tier):
    xml_headers_list = {'Content-Type':'application/vnd.cora.recordList+xml','Accept':'application/vnd.cora.recordList+xml'}
    tier = tier
    searchType = 'alvinRecord'
    query = '**' 
    json_safe_str = json.dumps(query) 
    location = request.GET.get('location', '').strip()

    if location != '':
        locationInRecordSearchTerm = f',{{"name":"locationInRecordSearchTerm","value":"alvin-location_{location}"}}' 
    else: 
        locationInRecordSearchTerm = ''

    params = request.GET.copy()  # make a mutable copy
    params.pop('page', None)  # remove the parameter if it exists
    view_url = f"{request.path}?{params.urlencode()}" if params else request.path
    separator = "/linkedart"
    current_url = request.build_absolute_uri()
    domain_root = current_url.split(separator, 1)[0]
    page_token = request.GET.get('page')
  
    if page_token:
        decoded_data = urlsafe_base64_decode(page_token)
        params = json.loads(decoded_data.decode('utf-8'))
        start = params.get('start', 1)
        rows = params.get('rows', 10)   
    else:
        start = 1       
        rows = 10

    startnum = int(start)
    rowsnum = int(rows)
    newstart = startnum + rowsnum
    newstartnum = int(newstart)
    prevstart = startnum - rowsnum
    prevstartnum = int(prevstart)
    next_params = {'start': newstart, 'rows': rows}       
    json_next = json.dumps(next_params).encode('utf-8')
    next_token = urlsafe_base64_encode(force_bytes(json_next))
    prev_params = {'start': prevstart, 'rows': rows}
    json_prev = json.dumps(prev_params).encode('utf-8')
    prev_token = urlsafe_base64_encode(force_bytes(json_prev))

    alvinRecordSearchData = f'{{"name":"alvinRecordSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"alvinRecordSearchTerm","value":{json_safe_str}}}{locationInRecordSearchTerm},{{"name":"visibilityAlvinSearchTerm","value":"published"}}]}}]}}'
  
     # API host
    api_host = settings.API_HOST

    if searchType == 'alvinRecord':
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={alvinRecordSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}'
       
    else:
        raise Http404("Invalid search") 
   
    response = requests.get(list_url, headers=xml_headers_list)
    
    if response.status_code == 200:
        xml_list = etree.fromstring(response.content)         
        records = []
        if searchType == 'alvinRecord':
            for record in xml_list.findall('data/record/data/record'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'collection': record.findtext('./collection'),
               })

        pages = {
            "fromNo":xml_list.findtext(".//fromNo"),
            "toNo":xml_list.findtext(".//toNo"),
            "totalNo":xml_list.findtext(".//totalNo"),
            }

        totalNo = pages.get("totalNo")          
        completeListSize = int(totalNo)     
        startnum = int(start)
        rowsnum = int(rows)
        newstart = startnum + rowsnum
        nextstartnum = int(newstart) 
        prevstart = startnum - rowsnum
        prevstartnum = int(prevstart)
        startIndex = startnum - 1

    else:
        raise Http404("Invalid search") 
  
    context = {       
        "location":location,
        "records":records,
        "completeListSize":completeListSize,
        "startnum":startnum,
        "rowsnum":rowsnum,
        "nextstartnum":nextstartnum,
        "prevstartnum":prevstartnum,
        "view_url":view_url,       
        "domain_root":domain_root,
        "next_token":next_token,
        "prev_token":prev_token,
        "startIndex":startIndex,
        }

    response = render(request, 'xml_formats/linked_art_search.json', context)

  # 2. Add or modify headers using the .headers dictionary
    response.headers['Content-Type'] = 'application/ld+json'  # Standard server response type
    response.headers['Accept'] = 'application/ld+json;profile="https://linked.art/ns/v1/linked-art.json"' # Any custom tracking header
    
  # 3. Return the modified response object
    return response

 