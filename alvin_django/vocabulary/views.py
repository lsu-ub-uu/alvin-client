from lxml import etree

class SafeHTTPResolver(etree.Resolver):
    def resolve(self, url, pubid, context):
        # Allow only HTTP/HTTPS URLs from trusted domains
        if url.startswith("http://") or url.startswith("https://"):
            # Example: restrict to example.com
            if "cora.alvin-portal.org" not in url:
                raise ValueError(f"Blocked external URL: {url}")
            
            # Fetch the content
            resp = requests.get(url, timeout=5)
            resp.raise_for_status()
            return self.resolve_string(resp.text, context)
        
        # Fallback to default resolution
        return None


from django.shortcuts import render, get_object_or_404
from django.http import Http404
from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
import requests

import urllib.request
from urllib.request import urlopen
parser = etree.XMLParser()
parser.resolvers.add(SafeHTTPResolver())

def accordion(request):
  template = loader.get_template('vocabulary/accordion.html')
  return HttpResponse(template.render())

def userguide(request):
  return render(request, 'vocabulary/userguide.html', {})

def api(request):
  return render(request, 'vocabulary/api.html', {})


def oai_pmh(request):
  return render(request, 'vocabulary/oai-pmh.html', {})

def iiif(request):  
  return render(request, 'vocabulary/iiif.html', {})

def vocabulary(request):
  return render(request, 'vocabulary/vocabulary.html', {})

def cataloguing(request):
  return render(request, 'vocabulary/cataloguing.html', {})

def place(request):
  return render(request, 'vocabulary/place.html', {})

def person(request):
  return render(request, 'vocabulary/person.html', {})

def organisation(request):
  return render(request, 'vocabulary/organisation.html', {})

def metadata(request, id, method="GET"):
  baseurl = 'https://cora.alvin-portal.org/rest/record/metadata/'
  url = baseurl + id
  req = urllib.request.Request(url)
  req.add_header('Accept', 'application/vnd.cora.record-decorated+xml')
 
  # Hämta incoming links
  base_url = f'https://cora.alvin-portal.org/rest/record/metadata/{id}/incomingLinks'
  response = requests.get(base_url)

  if response.status_code != 200:
      raise Http404("Record list not found")

  # Hantera XML for incoming links
  record_xml = etree.fromstring(response.content)
    
  # Extrahera metadata
  suba1 = record_xml.findtext("./data/recordToRecordLink[1]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba2 = record_xml.findtext("./data/recordToRecordLink[2]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba3 = record_xml.findtext("./data/recordToRecordLink[3]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba4 = record_xml.findtext("./data/recordToRecordLink[4]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba5 = record_xml.findtext("./data/recordToRecordLink[5]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba6 = record_xml.findtext("./data/recordToRecordLink[6]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba7 = record_xml.findtext("./data/recordToRecordLink[7]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba8 = record_xml.findtext("./data/recordToRecordLink[8]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba9 = record_xml.findtext("./data/recordToRecordLink[9]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba10 = record_xml.findtext("./data/recordToRecordLink[10]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba11 = record_xml.findtext("./data/recordToRecordLink[11]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba12 = record_xml.findtext("./data/recordToRecordLink[12]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba13 = record_xml.findtext("./data/recordToRecordLink[13]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba14 = record_xml.findtext("./data/recordToRecordLink[14]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba15 = record_xml.findtext("./data/recordToRecordLink[15]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba16 = record_xml.findtext("./data/recordToRecordLink[16]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba17 = record_xml.findtext("./data/recordToRecordLink[17]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba18 = record_xml.findtext("./data/recordToRecordLink[18]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba19 = record_xml.findtext("./data/recordToRecordLink[19]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba20 = record_xml.findtext("./data/recordToRecordLink[20]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba21 = record_xml.findtext("./data/recordToRecordLink[21]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba25 = record_xml.findtext("./data/recordToRecordLink[25]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba30 = record_xml.findtext("./data/recordToRecordLink[30]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba34 = record_xml.findtext("./data/recordToRecordLink[32]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba36 = record_xml.findtext("./data/recordToRecordLink[36]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba38 = record_xml.findtext("./data/recordToRecordLink[38]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba44 = record_xml.findtext("./data/recordToRecordLink[44]/from/[linkedRecordType='metadata']/linkedRecordId")
  suba46 = record_xml.findtext("./data/recordToRecordLink[46]/from/[linkedRecordType='metadata']/linkedRecordId") 
  
  if not suba1:
    sub1 = 'None'
  else:
    sub1 = suba1

  if not suba2:
    sub2 = 'None'
  else:
    sub2 = suba2

  if not suba3:
    sub3 = 'None'
  else:
    sub3 = suba3

  if not suba4:
    sub4 = 'None'
  else:
    sub4 = suba4

  if not suba5:
    sub5 = 'None'
  else:
    sub5 = suba5

  if not suba6:
    sub6 = 'None'
  else:
    sub6 = suba6

  if not suba7:
    sub7 = 'None'
  else:
    sub7 = suba7

  if not suba8:
    sub8 = 'None'
  else:
    sub8 = suba8

  if not suba9:
    sub9 = 'None'
  else:
    sub9 = suba9

  if not suba10:
    sub10 = 'None'
  else:
    sub10 = suba10

  if not suba11:
    sub11 = 'None'
  else:
    sub11 = suba11

  if not suba12:
    sub12 = 'None'
  else:
    sub12 = suba12

  if not suba13:
    sub13 = 'None'
  else:
    sub13 = suba13

  if not suba14:
    sub14 = 'None'
  else:
    sub14 = suba14

  if not suba15:
    sub15 = 'None'
  else:
    sub15 = suba15

  if not suba16:
    sub16 = 'None'
  else:
    sub16 = suba16

  if not suba17:
    sub17 = 'None'
  else:
    sub17 = suba17

  if not suba18:
    sub18 = 'None'
  else:
    sub18 = suba18

  if not suba19:
    sub19 = 'None'
  else:
    sub19 = suba19

  if not suba20:
    sub20 = 'None'
  else:
    sub20 = suba20

  if not suba21:
    sub21 = 'None'
  else:
    sub21 = suba21

  if not suba25:
    sub25 = 'None'
  else:
    sub25 = suba25

  if not suba30:
    sub30 = 'None'
  else:
    sub30 = suba30

  if not suba34:
    sub34 = 'None'
  else:
    sub34 = suba34

  if not suba36:
    sub36 = 'None'
  else:
    sub36 = suba36

  if not suba38:
    sub38 = 'None'
  else:
    sub38 = suba38

  if not suba44:
    sub44 = 'None'
  else:
    sub44 = suba44

  if not suba46:
    sub46 = 'None'
  else:
    sub46 = suba46

  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  argDict["sub1"] = etree.XSLT.strparam(sub1)
  argDict["sub2"] = etree.XSLT.strparam(sub2)
  argDict["sub3"] = etree.XSLT.strparam(sub3)
  argDict["sub4"] = etree.XSLT.strparam(sub4)
  argDict["sub5"] = etree.XSLT.strparam(sub5)
  argDict["sub6"] = etree.XSLT.strparam(sub6)
  argDict["sub7"] = etree.XSLT.strparam(sub7)
  argDict["sub8"] = etree.XSLT.strparam(sub8)
  argDict["sub9"] = etree.XSLT.strparam(sub9)
  argDict["sub10"] = etree.XSLT.strparam(sub10)
  argDict["sub11"] = etree.XSLT.strparam(sub11)
  argDict["sub12"] = etree.XSLT.strparam(sub12)
  argDict["sub13"] = etree.XSLT.strparam(sub13)
  argDict["sub14"] = etree.XSLT.strparam(sub14)
  argDict["sub15"] = etree.XSLT.strparam(sub15)
  argDict["sub16"] = etree.XSLT.strparam(sub16)
  argDict["sub17"] = etree.XSLT.strparam(sub17)
  argDict["sub18"] = etree.XSLT.strparam(sub18)
  argDict["sub19"] = etree.XSLT.strparam(sub19)
  argDict["sub20"] = etree.XSLT.strparam(sub20)
  argDict["sub21"] = etree.XSLT.strparam(sub21)
  argDict["sub25"] = etree.XSLT.strparam(sub25)
  argDict["sub30"] = etree.XSLT.strparam(sub30)
  argDict["sub34"] = etree.XSLT.strparam(sub34)
  argDict["sub36"] = etree.XSLT.strparam(sub36)
  argDict["sub38"] = etree.XSLT.strparam(sub38)
  argDict["sub44"] = etree.XSLT.strparam(sub44)
  argDict["sub46"] = etree.XSLT.strparam(sub46)

  with urllib.request.urlopen(req) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/metadata.xsl') as f:
    xslt_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/title_metadata.xsl') as f:
    xslt_title = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     # Create the XSLT transformer
  metadata = transform(xml_tree, **argDict)          # Transform source XML tree

  transform = etree.XSLT(xslt_title)     # Create the XSLT transformer
  title = transform(xml_tree, **argDict)            # Transform source XML tree
 
  return render (request, 'vocabulary/metadata.html', {'metadata': metadata, 'title': title, 'format': format})



