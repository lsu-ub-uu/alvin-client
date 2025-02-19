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
        'alvin-organisation': f'https://cora.alvin-portal.org/rest/record/alvin-organisation/{record_id}',
        'alvin-work': f'https://cora.alvin-portal.org/rest/record/alvin-work/{record_id}'
        
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

    # Skicka metadata och breadcrumbs till context
    context = {
        'metadata': metadata,
        'xml': response.content,
        "record_type": record_type
    }

    return render(request, f'alvin_viewer/alvin_viewer.html', context)

# Function to extract metadata based on record type
def extract_metadata(record_xml, record_type):

    metadata = {
        "id": record_xml.findtext(".//recordInfo/id"),
        "created": record_xml.findtext(".//tsCreated"),
        "last_updated": record_xml.findtext(".//tsUpdated"),
        "source_xml": record_xml.findtext("./actionLinks/read/url")
    }

    if record_type == 'alvin-place':

        authority_names = {}
        for authority in record_xml.xpath("//authority"): 
            geographic = authority.findtext("./geographic") or None
            authority_names[authority.get("lang")] = geographic

        variant_names = {}
        for variant in record_xml.xpath("//variant"): 
            geographic = variant.findtext("./geographic") or None
            variant_names[variant.get("lang")] = geographic
            

        metadata.update({
            "authority_names": authority_names,
            "variant_names": variant_names,
            "country": record_xml.findtext(".//country") or None,
            "latitude": record_xml.findtext(".//point/latitude") or None,
            "longitude": record_xml.findtext(".//point/longitude") or None,
        })

    elif record_type == 'alvin-person':

        authority_names = {}
        for authority in record_xml.xpath("//authority"): 
            family_name = authority.findtext("./name/namePart[@type = 'family']") or None
            given_name = authority.findtext("./name/namePart[@type = 'given']") or None
            term_of_address = authority.findtext("./name/namePart[@type = 'termsOfAddress']") or None

            authority_names[authority.get("lang")] = {
                            "family_name": family_name,
                            "given_name": given_name,
                            "term_of_address": term_of_address,
                            }

        print(authority_names)

        metadata.update({
            "authority_names": authority_names,
            "birth_year": record_xml.findtext(".//birthDate//year") or None,
            "death_year": record_xml.findtext(".//deathDate//year") or None,
            "birth_month": record_xml.findtext(".//birthDate//month") or None,
            "death_month": record_xml.findtext(".//deathDate//month") or None,
            "birth_date": record_xml.findtext(".//birthDate//day") or None,
            "death_date": record_xml.findtext(".//deathDate//day") or None,
            "field_of_endeavor": record_xml.findtext(".//fieldOfEndeavor") or None,
            "note": record_xml.findtext(".//note[@noteType = 'biographicalHistorical']") or None
        })

        print(metadata)

    return metadata