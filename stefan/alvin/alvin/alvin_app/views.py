from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
from django.utils.html import format_html
from lxml import etree
from urllib.request import urlopen
parser = etree.XMLParser()

def alvin_app(request):
  template = loader.get_template('myfirst.html')
  return HttpResponse(template.render())

def main(request):
  template = loader.get_template('main.html')
  return HttpResponse(template.render())

def about(request):
  template = loader.get_template('about.html')
  return HttpResponse(template.render())

def copyright(request):
  template = loader.get_template('copyright.html')
  return HttpResponse(template.render())

def help(request):
  template = loader.get_template('help.html')
  return HttpResponse(template.render())

def members(request):
  with urlopen('https://cora.alvin-portal.org/rest/record/alvin-location') as f:
    xml_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/members.xsl') as f:
    xslt_tree = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     # Create the XSLT transformer
  result = transform(xml_tree)          # Transform source XML tree

  member = format_html(etree.tostring(result, encoding='unicode', pretty_print=True))
  
  return render(request, 'members.html', {'member': member})

def location(request, id):
  current_path = request.get_full_path()
  str = (current_path)
  id = str[16:]
  baseurl = 'https://cora.alvin-portal.org/rest/record/alvin-location/'
  url = baseurl + id

  with urlopen(url) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/location.xsl') as f:
    xslt_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/title_location.xsl') as f:
    xslt_title = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     # Create the XSLT transformer
  result = transform(xml_tree)          # Transform source XML tree

  transform = etree.XSLT(xslt_title)     # Create the XSLT transformer
  title = transform(xml_tree)            # Transform source XML tree

  location = format_html(etree.tostring(result, encoding='unicode', pretty_print=True))
  
  return render(request, 'alvin-location.html', {'location': location, 'title': title})

def place(request, id):
  current_path = request.get_full_path()
  str = (current_path)
  id = str[13:]
  baseurl = 'https://cora.alvin-portal.org/rest/record/alvin-place/'
  url = baseurl + id

  with urlopen(url) as f:
    xml_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/place.xsl') as f:
    xslt_tree = etree.parse(f, parser)

  with urlopen('http://127.0.0.1:8000/static/xsl/title_place.xsl') as f:
    xslt_title = etree.parse(f, parser)

  transform = etree.XSLT(xslt_tree)     # Create the XSLT transformer
  result = transform(xml_tree)          # Transform source XML tree

  transform = etree.XSLT(xslt_title)     # Create the XSLT transformer
  title = transform(xml_tree)            # Transform source XML tree

  place = format_html(etree.tostring(result, encoding='unicode', pretty_print=True))
  
  return render(request, 'alvin-place.html', {'place': place, 'title': title})



