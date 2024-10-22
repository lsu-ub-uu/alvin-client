from django.shortcuts import render, get_object_or_404
from django.http import Http404
import requests
from lxml import etree

# Generaliserad view för flera typer
def alvin_viewer(request, record_type, record_id):
    
    # API URLs
    api_urls = {
        'alvin-place': f'https://cora.alvin-portal.org/rest/record/alvin-place/{record_id}',
        'alvin-person': f'https://cora.alvin-portal.org/rest/record/alvin-person/{record_id}',
    }

    if record_type not in api_urls:
        raise Http404("Invalid record type")
    
    # Hämta data från API
    api_url = api_urls[record_type]
    xml_headers_record = {'Content-Type':'application/vnd.uub.record+xml','Accept':'application/vnd.uub.record+xml'}
    response = requests.get(api_url, headers=xml_headers_record)

    if response.status_code != 200:
        raise Http404("Record not found")

    # Hantera XML
    record_xml = etree.fromstring(response.content)
    
    # Extrahera metadata
    metadata = extract_metadata(record_xml, record_type)

    # Generera breadcrumbs
    breadcrumbs = generate_breadcrumbs(record_type, record_id, metadata)

    # Skicka metadata och breadcrumbs till context
    context = {
        'metadata': metadata,
        'breadcrumbs': breadcrumbs,
        'xml': response.content,
    }
    
    template_name = str(record_type).replace('-','_')

    return render(request, f'alvin_viewer/{template_name}.html', context)


# Function to extract metadata based on record type
def extract_metadata(record_xml, record_type):
    if record_type == 'alvin-place':
        return {
            "authority_names": record_xml.xpath("//authority/geographic/text()"),
            "variant_names":list(zip(record_xml.xpath("//variant/geographic/text()"), record_xml.xpath("//variant/@lang"))),
            "country": record_xml.xpath("//country/text()"),
            "latitude": record_xml.xpath("//point/latitude/text()"),
            "longitude": record_xml.xpath("//point/longitude/text()"),
            "id": record_xml.xpath("//recordInfo/id/text()"),
        }
    '''elif record_type == 'alvin-person':
        return {
            "name": record_xml.xpath("//name/text()"),
            "birth_date": record_xml.xpath("//birthDate/text()"),
            "death_date": record_xml.xpath("//deathDate/text()"),
            "id": record_xml.xpath("//recordInfo/id/text()"),
        }'''
    return {}


# Generalized function to generate breadcrumbs based on record type
def generate_breadcrumbs(record_type, record_id, metadata):
    
    breadcrumbs = [
        {'name': '..', 'url': '/'},  # Start
    ]
    
    if record_type == 'alvin-place':
        place_name = metadata.get('authority_names')[0]
        breadcrumbs.append({'name': 'Platser', 'url': '/alvin-place/'})
        breadcrumbs.append({'name': place_name, 'url': f'/alvin-place/{record_id}/'})
    '''elif record_type == 'alvin-person':
        person_name = metadata.get('name')
        breadcrumbs.append({'name': 'Persons', 'url': '/alvin-person'})
        breadcrumbs.append({'name': person_name, 'url': f'/alvin-person/{record_id}'})'''

    return breadcrumbs