from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
import requests
from lxml import etree
import urllib.request
from urllib.request import urlopen
parser = etree.XMLParser()

def accordion(request):
  template = loader.get_template('accordion.html')
  return HttpResponse(template.render())

def userguide(request):
  template = loader.get_template('userguide.html')
  return HttpResponse(template.render())

def vocabulary(request):
  template = loader.get_template('vocabulary.html')
  return HttpResponse(template.render())

def cataloguing(request):
  template = loader.get_template('cataloguing.html')
  return HttpResponse(template.render())

def place(request):
  template = loader.get_template('place.html')
  return HttpResponse(template.render())

def person(request):
  template = loader.get_template('person.html')
  return HttpResponse(template.render())

def organisation(request):
  template = loader.get_template('organisation.html')
  return HttpResponse(template.render())

def metadata(request, id, method="GET"):
  current_path = request.get_full_path()
  str = (current_path)
  id = str[15:]
  baseurl = 'https://cora.alvin-portal.org/rest/record/metadata/'
  url = baseurl + id
  req = urllib.request.Request(url)
  req.add_header('Accept', 'application/vnd.cora.record-decorated+xml')
   
  #subbaseurl = 'https://cora.alvin-portal.org/rest/record/metadata/dateGroup/incomingLinks' 
  #subbaseurl = url + '/incomingLinks'
  #reqsub = urllib.request.Request(subbaseurl)

  #with urllib.request.urlopen(reqsub) as f:
  #  xml_tree_sub = etree.parse(f, parser)

  lang = request.LANGUAGE_CODE

  argDict = {}
  argDict["lang"] = etree.XSLT.strparam(lang)

  with urllib.request.urlopen(req) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/metadata.xsl') as f:
    xslt_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/title_metadata.xsl') as f:
    xslt_title = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     # Create the XSLT transformer
  result = transform(xml_tree, **argDict)          # Transform source XML tree

  transform = etree.XSLT(xslt_title)     # Create the XSLT transformer
  title = transform(xml_tree)            # Transform source XML tree
 
  metadata = result

  return render (request, 'metadata.html', {'metadata': metadata, 'title': title})