from django.shortcuts import render
import requests
from lxml import etree

# Create your views here.
def alvin_place(request, place_id):
        
    # Record headers
    xml_headers_record = {'Content-Type':'application/vnd.uub.record+xml','Accept':'application/vnd.uub.record+xml'}
    
    # From CORA preview
    preview_place_url = f'https://cora.epc.ub.uu.se/alvin/rest/record/alvin-place/{place_id}'

    # From CORA dev
    ## place_url = 'http://130.238.171.238:38081/alvin/rest/record/alvin-place/'

    response = requests.get(preview_place_url, headers=xml_headers_record)
    
    alvin_place_xml = etree.fromstring(response.content)
        
    metadata = {
        "authority_names":alvin_place_xml.xpath("//authority/geographic/text()"),
        "variant_names":list(zip(alvin_place_xml.xpath("//variant/geographic/text()"), alvin_place_xml.xpath("//variant/@lang"))),
        "country":alvin_place_xml.xpath("//country/text()"),
        "latitude":alvin_place_xml.xpath("//point/latitude/text()"),
        "longitude":alvin_place_xml.xpath("//point/longitude/text()"),
        "id":alvin_place_xml.xpath("//recordInfo/id/text()")
    }

    # Construct XSLT transformer
    alvin_place_xslt = etree.parse(r"static\xslt\alvin_place_xslt.xsl")
    transform = etree.XSLT(alvin_place_xslt)

    # Apply XSLT tranformation
    html = transform(alvin_place_xml)
    
    context = {
        "metadata": metadata,
        "xml": response.content,
        "html": html,
    }

    return render(request, "alvin_place/alvin_place.html", context)