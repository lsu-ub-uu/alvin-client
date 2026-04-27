from lxml import etree
from django.shortcuts import render, get_object_or_404
from django.http import Http404
from django.templatetags.static import static
from django.conf import settings
import requests
import urllib.request
from urllib.request import urlopen
parser = etree.XMLParser()

def userguide(request):
  return render(request, 'vocabulary/userguide.html', {})

def rest_api(request):
  return render(request, 'vocabulary/rest-api.html', {})

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

def metadata(request, id):
  api_host = settings.API_HOST
  base_url = api_host + '/rest/record/metadata/'
  url = base_url + id
  req = urllib.request.Request(url)
  req.add_header('Accept', 'application/vnd.cora.record-decorated+xml')
  xslt_path = static('xsl/metadata-html.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)
  xslt_title_path = static('xsl/title_metadata.xsl')
  absolute_xslt_title = request.build_absolute_uri(xslt_title_path)
  domain_root = request.build_absolute_uri('/')[:-1] 
 
  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  argDict["domain_root"] = etree.XSLT.strparam(domain_root)

  with urllib.request.urlopen(req) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt_title) as f:
    xslt_title = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     # Create the XSLT transformer
  metadata = transform(xml_tree, **argDict)          # Transform source XML tree

  transform = etree.XSLT(xslt_title)     # Create the XSLT transformer
  title = transform(xml_tree, **argDict)            # Transform source XML tree
 
  return render (request, 'vocabulary/metadata.html', {'metadata': metadata, 'title': title, 'format': format})

def onthology(request, id):
  id = id
  xml_path = '/onthology/alvin.rdf'
  absolute_xml = request.build_absolute_uri(xml_path)
  xslt_path = static('xsl/onthology-html.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)
  full_url = request.build_absolute_uri()
  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  argDict["full_url"] = etree.XSLT.strparam(full_url)
  argDict["id"] = etree.XSLT.strparam(id)
  
  with urllib.request.urlopen(absolute_xml) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
  onthology = transform(xml_tree, **argDict)	# Transform source XML tree

  return render (request, 'vocabulary/onthology.html', {'onthology': onthology, 'id': id})

def classes(request):
  xml_path = '/onthology/alvin.rdf'
  absolute_xml = request.build_absolute_uri(xml_path)
  xslt_path = static('xsl/classes-html.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)
  full_url = request.build_absolute_uri()
  lang = request.LANGUAGE_CODE
 
  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  argDict["full_url"] = etree.XSLT.strparam(full_url)

  with urllib.request.urlopen(absolute_xml) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
  classes = transform(xml_tree, **argDict)	# Transform source XML tree

  return render (request, 'vocabulary/classes.html', {'classes': classes})

def properties(request):
  xml_path = '/onthology/alvin.rdf'
  absolute_xml = request.build_absolute_uri(xml_path)
  xslt_path = static('xsl/properties-html.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)
  full_url = request.build_absolute_uri()
  lang = request.LANGUAGE_CODE
 
  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  argDict["full_url"] = etree.XSLT.strparam(full_url)
  
  with urllib.request.urlopen(absolute_xml) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
  properties = transform(xml_tree, **argDict)	# Transform source XML tree

  return render (request, 'vocabulary/properties.html', {'properties': properties})

def category(request):
  xml_path = '/onthology/alvin.rdf'
  absolute_xml = request.build_absolute_uri(xml_path)
  xslt_path = static('xsl/category-html.xsl')
  absolute_xslt = request.build_absolute_uri(xslt_path)
  full_url = request.build_absolute_uri()
  lang = request.LANGUAGE_CODE
 
  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)
  argDict["full_url"] = etree.XSLT.strparam(full_url)
  
  with urllib.request.urlopen(absolute_xml) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen(absolute_xslt) as f:
    xslt_tree = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
  category = transform(xml_tree, **argDict)	# Transform source XML tree

  return render (request, 'vocabulary/category.html', {'category': category})