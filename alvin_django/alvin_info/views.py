from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
from django.utils.translation import gettext as _
from django.utils.html import format_html
import requests
from lxml import etree
from urllib.request import urlopen
parser = etree.XMLParser()
from alvin_viewer.views import get_dates
from alvin_viewer.templatetags import metadata_wrangler


def start(request):
  template = loader.get_template('alvin_info/start.html')
  return HttpResponse(template.render())

def about(request):
  template = loader.get_template('alvin_info/about.html')
  return HttpResponse(template.render())

def copyright(request):
  template = loader.get_template('alvin_info/copyright.html')
  return HttpResponse(template.render())

def help(request):
  template = loader.get_template('alvin_info/help.html')
  return HttpResponse(template.render())

def institutions(request):
  xml_headers_list = {'Content-Type':'application/vnd.cora.recordList+xml','Accept':'application/vnd.cora.recordList+xml'}
    
  # API host
  api_host = 'https://cora.alvin-portal.org'

  list_url = f'{api_host}/rest/record/alvin-location'

  response = requests.get(list_url, headers=xml_headers_list)

  # Hantera XML
  list_xml = etree.fromstring(response.content)
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

def location(request):
  template = loader.get_template('location.html')
  return HttpResponse(template.render())

