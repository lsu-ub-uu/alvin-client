from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
from django.utils.translation import gettext as _
from django.utils.html import format_html
from django.templatetags.static import static
from django.conf import settings

import requests
import random

from lxml import etree
from urllib.request import urlopen

parser = etree.XMLParser()
#from alvin_viewer.extractors.common import dates

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

def start(request):
  HERO_BACKGROUNDS = [
    {
        "file": "img/heroBackground/88495.webp",
        "title": "Carta Marina",
        "url": "https://urn.kb.se/resolve?urn=urn:nbn:se:alvin:portal:record-88495",
    },
    {
        "file": "img/heroBackground/83600.webp",
        "title": "Historia natvralis ranarvm nostrativm",
        "url": "http://urn.kb.se/resolve?urn=urn:nbn:se:alvin:portal:record-83600",
    },
    {
        "file": "img/heroBackground/98114.webp",
        "title": "Okänd dam, tidigare kallad Cecilia Vasa",
        "url": "http://urn.kb.se/resolve?urn=urn:nbn:se:alvin:portal:record-98114",
    },
    {
        "file": "img/heroBackground/71343.webp",
        "title": "Universitetsbiblioteket i Lund, läsesalen ca 1900",
        "url": "http://urn.kb.se/resolve?urn=urn:nbn:se:alvin:portal:record-71343",
    },
    {
        "file": "img/heroBackground/120757.webp",
        "title": "Bilderbok för vuxna",
        "url": "http://urn.kb.se/resolve?urn=urn:nbn:se:alvin:portal:record-120757",
    },
    {
        "file": "img/heroBackground/80893.webp",
        "title": "Corporum Coelestium Magnitudines",
        "url": "http://urn.kb.se/resolve?urn=urn:nbn:se:alvin:portal:record-80893",
    },
  ]

  context = {
     "hero_bg": random.choice(HERO_BACKGROUNDS),
  }

  return render(request, 'alvin_info/start.html', context)

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

  response = requests.get(list_url, headers=xml_headers_list)

  if response.status_code == 200:

    list_url = etree.XML(response.content)

  if response.status_code == 200:
      list_xml = etree.fromstring(response.content)         
      records = []
      for record in list_url.findall('data/record/data/location'):
        records.append({
          'identifier': record.findtext('./recordInfo/id'),
          'nameone': record.findtext('./authority[1]/name/namePart[1]'),
          'member': record.findtext('./organisationInfo/descriptor'),
          }) 
  
  else:
    raise Http404("Record not found")  

  metadata = {
            "fromNo":list_xml.findtext(".//fromNo"),
            "toNo":list_xml.findtext(".//toNo"),
            "totalNo":list_xml.findtext(".//totalNo"),
        }

  context = {
            "metadata": metadata,
            "records":records,    
        } 

  return render(request, 'alvin_info/institutions.html', context)
