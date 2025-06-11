from django.shortcuts import render, get_object_or_404
from django.http import Http404, JsonResponse
from django.utils.translation import get_language
from django.conf import settings
import requests
import json
from lxml import etree


# Globala variabler och funktioner
xml_headers_record = {
    'Content-Type':'application/vnd.cora.record+xml',
    'Accept':'application/vnd.cora.record+xml',
    }

def get_authority_names(metadata, name_parts):
    # Extraherar auktoritetsnamn baserat på en angiven dict, name_parts, där nyckeln är ett metadatafält och värdet är en xpath.
    return {
        name.get("lang"): {
            key: name.findtext(xpath)
            for key, xpath in name_parts.items()
        }
        for name in metadata.xpath("//authority")
    }

def get_variant_names(metadata, name_parts):
    # Extraherar alternativa namn baserat på en angiven dict, name_parts, där nyckeln är ett metadatafält och värdet är en xpath.
    result = {}
    for key, xpath in name_parts.items():
        if xpath.startswith("./@"):
            attribute = xpath[3:]
            result[key] = metadata.get(attribute)
        else:
            result[key] = metadata.findtext(xpath)
    return result

def get_dates(date_type, record_xml):
    date_parts = filter(None, [
        record_xml.findtext(f".//{date_type}Date//year"),
        record_xml.findtext(f".//{date_type}Date//month"),
        record_xml.findtext(f".//{date_type}Date//day")
    ])
    date_str = "-".join(date_parts)
    era = record_xml.findtext(f".//{date_type}Date//era")
    return f"{date_str} {era}" if era else date_str

def get_date_other(record_xml):
    return [{
            "start_date": get_dates("start", date), 
            "end_date": get_dates("end", date),
            "type": date.get("type"),
            "date_note": date.findtext("./note"),
            } 
            for date in record_xml.xpath("//dateOther")]

def get_electronic_locators(record_xml):
    return [{
            "url": electronic_locator.findtext("./url"),
            "display_label":electronic_locator.findtext("./displayLabel")
            }
            for electronic_locator in record_xml.xpath("//electronicLocator")]

def get_related(record_xml, type):
    return [
            {
            "id": related.findtext(".//linkedRecordId"),
            "url": related.findtext(".//url")
            }
            for related in record_xml.xpath(f"//related[@type='{type}']")]

def get_agents(record_xml):
    return [{
            "type": f'alvin-{agent.get("type")}',
            "id": agent.findtext(".//linkedRecordId"),
            "role": [role.findtext(".") for role in agent.xpath(".//role")],
            "certainty": agent.findtext("./certainty")
            } for agent in record_xml.xpath("//agent")]

def get_origin_places(record_xml):
    return [{"id": origin_place.findtext(".//linkedRecordId"),
            "country": origin_place.findtext(".//country"),
            "historical_country": origin_place.findtext(".//historicalCountry"),
            "certainty": origin_place.findtext(".//certainty"),
            "publication": [publication.findtext(".") for publication in origin_place.xpath("..//publication")],
            } for origin_place in record_xml.xpath('//originPlace')]

# Generaliserad view för flera typer
def alvin_viewer(request, record_type, record_id):

    base_url = f'{settings.API_HOST}/rest/record/'

    # API URLs
    api_urls = {
        'alvin-place': f'alvin-place/{record_id}',
        'alvin-person': f'alvin-person/{record_id}',
        'alvin-organisation': f'alvin-organisation/{record_id}',
        'alvin-work': f'alvin-work/{record_id}',
        'alvin-record': f'alvin-record/{record_id}',
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
    }

    return render(request, 'alvin_viewer/alvin_viewer.html', context)

# Extrahera metadata baserat på recordType
def extract_metadata(record_xml, record_type):

    # Gemensam metadata
    metadata = {
        "id": record_xml.findtext(".//recordInfo/id"),
        "created": record_xml.findtext(".//tsCreated"),
        "last_updated": record_xml.xpath("//tsUpdated")[-1].findtext("."),
        "source_xml": record_xml.findtext("./actionLinks/read/url"),
        "record_type": record_type,
    }

    if record_type == 'alvin-place':
        metadata.update(extract_place_metadata(record_xml))
    elif record_type == 'alvin-person':
        metadata.update(extract_person_metadata(record_xml))
    elif record_type == 'alvin-organisation':
        metadata.update(extract_organisation_metadata(record_xml))
    elif record_type == 'alvin-work':
        metadata.update(extract_work_metadata(record_xml))
    elif record_type == 'alvin-record':
        metadata.update(extract_record_metadata(record_xml))

    return metadata

def extract_place_metadata(record_xml):
    
    authority_name_parts = {
            "geographic": "./geographic",
            "orientation_code": "./orientationCode",
        }

    variant_name_parts = {
            "language": "./@lang",
            "geographic": "./geographic",
            "orientation_code": "./orientationCode",
        }
    
    return {
        "authority_names": get_authority_names(record_xml, authority_name_parts),
        "variant_names": [get_variant_names(name, variant_name_parts) for name in record_xml.xpath("//variant")],
        "country": record_xml.findtext(".//country"),
        "latitude": record_xml.findtext(".//point/latitude"),
        "longitude": record_xml.findtext(".//point/longitude"),
    }

def extract_person_metadata(record_xml):
    
    authority_name_parts = {
            "family_name": "./name/namePart[@type='family']",
            "given_name": "./name/namePart[@type='given']",
            "numeration": "./name/namePart[@type='numeration']",
            "terms_of_address": "./name/namePart[@type='termsOfAddress']",
            "orientation_code": "./name/orientationCode",
            "variant_type": "variantType",
        }

    # Variantnamn måste hanteras separat eftersom de kan innehålla olika namn på samma språk
    variant_name_parts = {
            "language": "./@lang",
            "family_name": "./name/namePart[@type='family']",
            "given_name": "./name/namePart[@type='given']",
            "numeration": "./name/namePart[@type='numeration']",
            "terms_of_address": "./name/namePart[@type='termsOfAddress']",
            "orientation_code": "./name/orientationCode",
            "variant_type": "variantType",
        }
        
    return {
        "authority_names": get_authority_names(record_xml, authority_name_parts),
        "variant_names": [get_variant_names(name, variant_name_parts) for name in record_xml.xpath("//variant")],
        "birth_date": get_dates("birth", record_xml),
        "birth_place": record_xml.findtext('.//birthPlace//linkedRecordId'),
        "death_date": get_dates("death", record_xml),
        "death_place": record_xml.findtext(".//deathPlace//linkedRecordId"),
        "display_date": record_xml.findtext(".//displayDate"),
        "nationality": [nation.findtext("./country") for nation in record_xml.xpath("//nationality")],
        "gender": record_xml.findtext(".//gender"),
        "fields_of_endeavor": [field.findtext(".") for field in record_xml.xpath("//fieldOfEndeavor")],
        "notes": {note.get("noteType"): note.findtext(".") for note in record_xml.xpath("//note")},
        "identifiers": {identifier.get("type"): identifier.findtext(".") 
                    for identifier in record_xml.xpath("//identifier")},
        "electronic_locators": get_electronic_locators(record_xml),
        "related_persons": get_related(record_xml, 'person'),
        "related_organisations": get_related(record_xml, 'organisation'),
    }

def extract_organisation_metadata(record_xml):
    
    authority_name_parts = {
            "corporate_name": "./name/namePart[@type='corporateName']",
            "subordinate_name": "./name/namePart[@type='subordinate']",
            "terms_of_address": "./name/namePart[@type='termsOfAddress']",
            "variant_type": "variantType",
            "orientation_code": "./name/orientationCode",
            }

    variant_name_parts = {
            "language": "./@lang",
            "corporate_name": "./name/namePart[@type='corporateName']",
            "subordinate_name": "./name/namePart[@type='subordinate']",
            "terms_of_address": "./name/namePart[@type='termsOfAddress']",
            "variant_type": "./@variantType",
            "orientation_code": "./name/orientationCode",
            }
    
    return {
    "authority_names": get_authority_names(record_xml, authority_name_parts),
    "variant_names": [get_variant_names(name, variant_name_parts) for name in record_xml.xpath("//variant")],
    "start_date": get_dates("start", record_xml),
    "end_date": get_dates("end", record_xml),
    "display_date": record_xml.findtext(".//displayDate"),
    "notes": {note.get("noteType"): note.findtext(".") 
                for note in record_xml.xpath("//note")},
    "identifiers": {identifier.get("type"): identifier.findtext(".") 
                    for identifier in record_xml.xpath("//identifier")},
    "address": 
        {"box":record_xml.findtext(".//address/postOfficeBox"), 
        "street":record_xml.findtext(".//address/street"), 
        "postcode":record_xml.findtext(".//address/postcode"),
        "place_id":record_xml.findtext('.//address/place//linkedRecordId'),
        "country": record_xml.findtext('.//address/country'),
        },
    "electronic_locators": get_electronic_locators(record_xml),
    "related_organisations": [{
            "type": related_organisation.get("type"),
            "id": related_organisation.findtext(".//linkedRecordId"),
            "url": related_organisation.findtext(".//url"),
            } for related_organisation in record_xml.xpath("//related")],
    }

def extract_work_metadata(record_xml):
    
    def get_titles(title_type):
        return [
            {"main_title": title.findtext("./mainTitle"),
            "subtitle": title.findtext("./subtitle"),
            "orientation_code": title.findtext("./orientationCode"),
            "type": title.get("variantType"),
            } for title in record_xml.xpath(f"//{title_type}")]

    return {
    "form_of_work": record_xml.findtext(".//formOfWork"),
    "main_title": get_titles("//work/title"),
    "variant_titles": get_titles("//variantTitle"),
    "start_date": get_dates("start", record_xml),
    "end_date": get_dates("end", record_xml),
    "origin_places": get_origin_places(record_xml),
    "display_date": record_xml.findtext(".//displayDate"),
    "date_other": get_date_other(record_xml),
    "incipit": record_xml.findtext(".//incipit"),
    "literature": record_xml.findtext(".//listBibl"),
    "note": record_xml.findtext(".//work/note"),
    "literature": record_xml.findtext(".//work/listBibl"),
    "agents": get_agents(record_xml),
    "longitude": record_xml.findtext(".//point/longitude"),
    "latitude": record_xml.findtext(".//point/latitude"),
    }

def extract_record_metadata(record_xml):
    
    def get_titles(title_type):
        return [
            {
            "type": title.get("variantType"),
            "main_title": title.findtext("./mainTitle"),
            "subtitle": title.findtext("./subtitle"),
            "orientation_code": title.findtext("./orientationCode"),
            } for title in record_xml.xpath(f"//{title_type}")]



    def get_subject_authority(type):
        return [{
            "id": authority.findtext(".//linkedRecordId"),
            } for authority in record_xml.xpath(f"//record/subject[@type = '{type}']")]
    
    return {
    "type_of_resource": record_xml.findtext(".//data/record/typeOfResource"),
    "main_title": get_titles("//data/record/title"),
    "variant_titles": get_titles("//data/record/variantTitle"),
    "agents": get_agents(record_xml),
    "edition_statement": record_xml.findtext(".//record/editionStatement"),
    "publications": [publication.findtext(".") for publication in record_xml.xpath("//data/record/publication")],
    "origin_places": get_origin_places(record_xml),
    "start_date": get_dates("start", record_xml),
    "end_date": get_dates("end", record_xml),
    "display_date": record_xml.findtext(".//displayDate"),
    "date_other": get_date_other(record_xml),
    "physical_location": {
        "held_by": record_xml.findtext(".//physicalLocation/heldBy/location/linkedRecordId"),
        "sublocation": record_xml.findtext(".//physicalLocation/sublocation"),
        "shelf_mark": record_xml.findtext(".//physicalLocation/shelfMark"),
        "former_shelf_mark": [shelfmark.findtext(".") for shelfmark in record_xml.xpath("//physicalLocation/formerShelfMark")],
        "subcollection": [subcollection.findtext(".") for subcollection in record_xml.xpath("//physicalLocation/subcollection/*")],
        "note": record_xml.findtext(".//physicalLocation/note[@noteType='general']"),
    },
    "languages": [language.findtext(".") for language in record_xml.xpath("//data/record/language")],
    "description_languages": [language.findtext(".") for language in record_xml.xpath("//data/record/adminMetadata/descriptionLanguage")],
    "base_material": [material.findtext(".") for material in record_xml.xpath("//baseMaterial")],
    "extent": record_xml.findtext(".//record/extent"),
    "dimensions": [
                    {"scope": dimension.findtext("./scope"),
                    "height": dimension.findtext("./height"),
                    "width": dimension.findtext("./width"),
                    "depth": dimension.findtext("./depth"),
                    "diameter": dimension.findtext("./diameter"),
                    "unit": dimension.findtext("./unit"),
                    "scope": dimension.findtext("./scope"),}
                    for dimension in record_xml.xpath("//data/record/dimensions")],
    "physical_description_notes": [{
        "type": note.get("noteType"),
        "note": note.findtext("."),
    } for note in record_xml.xpath("//physicalDescription/note")],
    "notes": [{
        "type": note.get("noteType"),
        "note": note.findtext("."),
        } 
        for note in record_xml.xpath("//record/note")],
    "summary": record_xml.findtext(".//record/summary"),
    "transcription": record_xml.findtext(".//record/transcription"),
    "table_of_contents": record_xml.findtext(".//record/tableOfContents"),
    "literature": record_xml.findtext(".//record/listBibl"),
    "access_policy": record_xml.findtext(".//record/accessPolicy"),
    "identifiers": [{
        "type": identifier.get("type"),
        "identifier": identifier.findtext("."),
        } 
        for identifier in record_xml.xpath("//record/identifier")],
    "genre_form": [genre.findtext(".") for genre in record_xml.xpath("//data/record/genreForm")],
    "subjects": [{
        "type": subject.get("authority"),
        "topic": subject.findtext(".//topic"),
        "genreForm": subject.findtext(".//genreForm"),
        "geographicCoverage": subject.findtext(".//geographicCoverage"),
        "temporal": subject.findtext(".//temporal"),
        "occupation": subject.findtext(".//occupation"),
        } for subject in record_xml.xpath("//record/subject[not(@type = 'person' or @type = 'organisation' or @type = 'place')]")],
    "subject_person": get_subject_authority('person'),
    "subject_organisation": get_subject_authority('organisation'),
    "subject_place": get_subject_authority('place'),
    "classifications": [{
        "type": classification.get("authority"),
        "classification": classification.findtext("."),
    } for classification in record_xml.xpath("//record/classification")],
    "related_records": [{
        "type": record.get("relatedToType"),
        "id": record.findtext("./record/linkedRecordId"),
        "parts": [
                {
                "type": part.get("partType"),
                "number": part.findtext("./partNumber"),
                "extent": part.findtext("./extent"),
            } for part in record.xpath("part")],
        } for record in record_xml.xpath("//relatedTo")],
    "electronic_locators": get_electronic_locators(record_xml),
    "files": record_xml.xpath("//record//file"),
    }

def iiif_manifest(request, record_id):

    base_url = request.build_absolute_uri()

    record_url = f"{base_url}/alvin-record/{record_id}"
    response = requests.get(record_url, headers=xml_headers_record)

    record_xml = etree.fromstring(response.content)

    def get_files(record_xml):

        file_list = []

        for i, file in enumerate(record_xml.xpath("//file"), start=1):

            response = requests.get(file.findtext(".//url"))
            file_xml = etree.fromstring(response.content)

            canvas_id = f"{base_url}canvas/{i}"
            image_id = f"{file_xml.findtext('.//iiif/server')}/{file_xml.findtext('.//iiif/identifier')}"

            file_list.append({
                "id": canvas_id,
                "type": "Canvas",
                "height": int(file_xml.findtext('.//master/height')),
                "width": int(file_xml.findtext('.//master/width')),
                "items": [
                    {
                    "id": f"{canvas_id}/page",
                    "type": "AnnotationPage",
                    "items": [
                        {
                        "id": f"{canvas_id}/page/anno",
                        "type": "Annotation",
                        "motivation": "painting",
                        "body": {
                            "id": f"{image_id}/full/full/0/default.jpg",
                            "type": "Image",
                            "format": "image/jpeg",
                            "height": int(file_xml.findtext('.//master/height')),
                            "width": int(file_xml.findtext('.//master/width'))
                            },
                        }
                    ],
                }
                ],
                "rendering": [
                    {
                    "id": "https://example.org/images/123/full/full/0/default.jpg",
                    "type": "Image",
                    "format": "image/jpeg",
                    "label": "Download original image"
                    }
                ]
            })

        return file_list

    manifest = {
        "@context": "http://iiif.io/api/presentation/3/context.json",
        "id": request.build_absolute_uri(),
        "type": "Manifest",
        #"label": " : ".join(filter(None, [record_xml.findtext(".//title/mainTitle"), record_xml.findtext(".//title/subtitle")])),
        "items": get_files(record_xml),
    }

    return JsonResponse(manifest)