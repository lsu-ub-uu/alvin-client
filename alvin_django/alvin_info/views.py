from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
from django.utils.translation import gettext as _
from django.utils.html import format_html
from django.templatetags.static import static
from django.conf import settings
import requests
from lxml import etree
from urllib.request import urlopen
parser = etree.XMLParser()
#from alvin_viewer.extractors.common import dates

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
  api_host = settings.API_HOST

  list_url = f'{api_host}/rest/record/alvin-location'

  xslt_path = static('xsl/members.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)

  full_url = request.build_absolute_uri('/alvin-location/')

  response = requests.get(list_url, headers=xml_headers_list)

  # Hantera XML
  list_xml = etree.XML(response.content)
 
  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  argDict["full_url"] = etree.XSLT.strparam(full_url)
  
  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)
    
    xslt = etree.XSLT(xslt_tree)
    
    result = xslt(list_xml, **argDict)

  member = format_html(etree.tostring(result, encoding='unicode', pretty_print=True))


  metadata = {
            "fromNo":list_xml.findtext(".//fromNo"),
            "toNo":list_xml.findtext(".//toNo"),
            "totalNo":list_xml.findtext(".//totalNo"),
        }

  context = {
	    "member": member,
            "metadata": metadata,
            "full_url": full_url,
        }
  
    
  return render(request, 'alvin_info/institutions.html', context)