from django.shortcuts import render, get_object_or_404
from django.http import Http404
from django.utils.translation import get_language
import requests
from lxml import etree

# Globala variabler och funktioner
xml_headers_record = {
    'Content-Type':'application/vnd.uub.record+xml',
    'Accept':'application/vnd.uub.record+xml',
    }

def get_dates(date_type, record_xml):
    date_parts = filter(None, [
        record_xml.findtext(f".//{date_type}Date//year"),
        record_xml.findtext(f".//{date_type}Date//month"),
        record_xml.findtext(f".//{date_type}Date//day")
    ])

    date_str = "-".join(date_parts)

    era = record_xml.findtext(f".//{date_type}Date//era")
    
    return f"{date_str} {era}" if era else date_str

# Generaliserad view för flera typer
def alvin_viewer(request, record_type, record_id):

    base_url = 'https://cora.alvin-portal.org/rest/record/'

    # API URLs
    api_urls = {
        'alvin-place': f'alvin-place/{record_id}',
        'alvin-person': f'alvin-person/{record_id}',
        'alvin-organisation': f'alvin-organisation/{record_id}',
        'alvin-work': f'alvin-work/{record_id}'
    }

    if record_type not in api_urls:
        raise Http404("Invalid record type")
    
    # Hämta data från API
    api_url = base_url + api_urls[record_type]
    response = requests.get(api_url, headers=xml_headers_record)

    if response.status_code != 200:
        raise Http404("Record not found")

    # Hantera XML
    record_xml = etree.fromstring(response.content)
    
    # Extrahera metadata
    metadata = extract_metadata(record_xml, record_type)

    # Skicka metadata till context
    context = {
        'metadata': metadata,
        'xml': response.content,
        "record_type": record_type
    }

    return render(request, f'alvin_viewer/alvin_viewer.html', context)

# Extrahera metadata baserat på recordType
def extract_metadata(record_xml, record_type):

    # Gemensam metadata
    metadata = {
        "id": record_xml.findtext(".//recordInfo/id"),
        "created": record_xml.findtext(".//tsCreated"),
        "last_updated": record_xml.xpath("//tsUpdated")[-1].findtext("."),
        "source_xml": record_xml.findtext("./actionLinks/read/url"),
        "record_type": record_type
    }

    if record_type == 'alvin-place':

        def get_names(name_type):
            return {
                name.get("lang"): {
                "geographic": name.findtext("./geographic"),
            }
            for name in record_xml.xpath(f"//{name_type}")
        }

        authority_names = get_names('authority')
        variant_names = get_names('variant')
            

        metadata.update({
            "authority_names": authority_names,
            "variant_names": variant_names,
            "country": record_xml.findtext(".//country"),
            "latitude": record_xml.findtext(".//point/latitude"),
            "longitude": record_xml.findtext(".//point/longitude"),
        })

    elif record_type == 'alvin-person':

        def get_names(name_type):
            return {
                name.get("lang"): {
                "family_name": name.findtext("./name/namePart[@type='family']"),
                "given_name": name.findtext("./name/namePart[@type='given']"),
                "numeration": name.findtext("./name/namePart[@type='numeration']"),
                "term_of_address": name.findtext("./name/namePart[@type='termsOfAddress']")
            }
            for name in record_xml.xpath(f"//{name_type}")
        }
        
        authority_names = get_names("authority")
        variant_names = get_names("variant")
        
        birth_date = get_dates("birth", record_xml)
        death_date = get_dates("death", record_xml)
        
        metadata.update({
            "authority_names": authority_names,
            "variant_names": variant_names,
            "birth_date": birth_date,
            "birth_place": record_xml.findtext('.//birthPlace//linkedRecordId'),
            "death_date": death_date,
            "death_place": record_xml.findtext(".//deathPlace//url"),
            "display_date": record_xml.findtext(".//displayDate"),
            "nationality": [nation.findtext("./country") for nation in record_xml.xpath("//nationality")],
            "gender": record_xml.findtext(".//gender"),
            "fields_of_endeavor": [field.findtext(".") for field in record_xml.xpath("//fieldOfEndeavor")],
            "notes": {note.get("noteType"): note.findtext(".") for note in record_xml.xpath("//note")},
            "electronic_locators": [{
                "url": electronic_locator.findtext("./url"),
                "display_label":electronic_locator.findtext("./displayLabel")}
            
                for electronic_locator in record_xml.xpath("//electronicLocator")],
            "related_persons": [
                {"id": related_person.findtext(".//linkedRecordId"),
                 "url": related_person.findtext(".//url")}
            
                for related_person in record_xml.xpath("//related[@type='person']")],
            "related_organisations": [{
                "id": related_organisation.findtext(".//linkedRecordId"),
                "url": related_organisation.findtext(".//url")} 
                
                for related_organisation in record_xml.xpath("//related[@type='organisation']")],
        })

    elif record_type == 'alvin-organisation':
        
        def get_names(name_type):
            return {
                name.get("lang"): {
                "corporate_name": name.findtext("./name/namePart[@type='corporateName']"),
                "subordinate_name": name.findtext("./name/namePart[@type='subordinate']"),
                "term_of_address": name.findtext("./name/namePart[@type='termsOfAddress']"),
                "variant_type": name.get("variantType"),
                }
                for name in record_xml.xpath(f"//{name_type}")
            }
        
        authority_names = get_names("authority")
        variant_names = get_names("variant")

        metadata.update({
        "authority_names": authority_names,
        "variant_names": variant_names,
        "start_date": get_dates("start", record_xml),
        "end_date": get_dates("end", record_xml),
        "display_date": record_xml.findtext(".//displayDate"),
        "notes": {note.get("noteType"): note.findtext(".") 
                  for note in record_xml.xpath("//note")},
        "identifiers": {identifier.get("type"): identifier.findtext(".") 
                        for identifier in record_xml.xpath("//identifier")},
        "adress": 
            {"box":record_xml.findtext(".//address/postOfficeBox"), 
                "street":record_xml.findtext(".//address/street"), 
                "postcode":record_xml.findtext(".//address/postcode"),
                "street":record_xml.findtext(".//address/street"),
                "place":record_xml.findtext('.//address/place//linkedRecordId'),
                "country": record_xml.findtext('.//address/country'),
                },
        "electronic_locators": 
            [{
                "url": electronic_locator.findtext("./url"), 
                "display_label":electronic_locator.findtext("./displayLabel")
                } 
              
            for electronic_locator in record_xml.xpath("//electronicLocator")],
        "related_organisations": 
            [{
                "type": related_organisation.get("type"),
                "id": related_organisation.findtext(".//linkedRecordId"),
                "url": related_organisation.findtext(".//url"),
                }
                
            for related_organisation in record_xml.xpath("//related")],
        
        })

    return metadata