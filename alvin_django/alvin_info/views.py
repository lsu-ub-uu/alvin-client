from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
from django.utils.translation import gettext as _
from django.utils.html import format_html
import requests
from lxml import etree
from urllib.request import urlopen
parser = etree.XMLParser()
from alvin_viewer.extractors.common import dates
from alvin_viewer.templatetags import metadata_wrangler


def start(request):
  return render(request, 'alvin_info/start.html', {})

def about(request):
  return render(request, 'alvin_info/about.html', {})

def copyright(request):
  return render(request, 'alvin_info/copyright.html', {})

def help(request):
  return render(request, 'alvin_info/help.html', {})

def institutions(request):
  xml_headers_list = {'Content-Type':'application/vnd.cora.recordList+xml','Accept':'application/vnd.cora.recordList+xml'}
    
  # API host
  api_host = 'https://cora.alvin-portal.org'

  list_url = f'{api_host}/rest/record/alvin-location'

  response = requests.get(list_url, headers=xml_headers_list)

  # Hantera XML
  #list_xml = etree.fromstring(response.content)
  list_xml = etree.XML(response.content)
 
  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  
  with urlopen('http://127.0.0.1:8000/static/xsl/members.xsl') as f:
    xslt_tree = etree.parse(f, parser)
    
    xslt = etree.XSLT(xslt_tree)
    
    result = xslt(list_xml, **argDict)

  #transform = etree.XSLT(xslt_tree)     # Create the XSLT transformer
  #result = transform(list_xml)          # Transform source XML tree

  member = format_html(etree.tostring(result, encoding='unicode', pretty_print=True))


  metadata = {
            "fromNo":list_xml.findtext(".//fromNo"),
            "toNo":list_xml.findtext(".//toNo"),
            "totalNo":list_xml.findtext(".//totalNo"),
        }

  context = {
	    "member": member,
            "metadata": metadata,
        }
  
    
  return render(request, 'alvin_info/institutions.html', context)

def location(request, id):
  xml_headers_list = {'Content-Type':'application/vnd.cora.record-decorated+xml','Accept':'application/vnd.cora.record-decorated+xml'}
  # API host
  api_host = 'https://cora.alvin-portal.org'

  list_url = f'{api_host}/rest/record/alvin-location/{id}'

  response = requests.get(list_url, headers=xml_headers_list)
 
  # Hantera XML
  list_xml = etree.fromstring(response.content)
  #list_xml = etree.XML(response.content)
  records = []
  for record in list_xml.findall('./data/location'):
      records.append({
          'identifier': record.findtext('./recordInfo/id'),
          'locationsv': record.findtext('./authority[@lang = "swe"]/name/namePart'),
          'locationen': record.findtext('./authority[@lang = "eng"]/name/namePart'),
          'locationno': record.findtext('./authority[@lang = "nor"]/name/namePart'),
           })

 
  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)

  with urlopen('http://127.0.0.1:8000/static/xsl/location_overview.xsl') as f:
    xslt_tree = etree.parse(f, parser)  
    xslt = etree.XSLT(xslt_tree)   
    result_overview = xslt(list_xml, **argDict)

  with urlopen('http://127.0.0.1:8000/static/xsl/location_all.xsl') as f:
    xslt_tree = etree.parse(f, parser)  
    xslt = etree.XSLT(xslt_tree)   
    result_all = xslt(list_xml, **argDict)

  with urlopen('http://127.0.0.1:8000/static/xsl/location_related.xsl') as f:
    xslt_tree = etree.parse(f, parser)  
    xslt = etree.XSLT(xslt_tree)   
    result_related = xslt(list_xml, **argDict)

  location_overview = format_html(etree.tostring(result_overview, encoding='unicode', pretty_print=True))
  location_all = format_html(etree.tostring(result_all, encoding='unicode', pretty_print=True))
  location_related = format_html(etree.tostring(result_related, encoding='unicode', pretty_print=True))

  metadata = {
      "record_type": 'alvin-location',
      "id": id,
      "title":list_xml.findtext('./data/location/authority[1]/name/namePart'),
      }

  context = {      
      "records":records,
      "metadata": metadata,
      "location_overview": location_overview,
      "location_all": location_all,  
      "location_related": location_related,      
      }
  
  return render(request, 'alvin_info/alvin-location.html', context)
