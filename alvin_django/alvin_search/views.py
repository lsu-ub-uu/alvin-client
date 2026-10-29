from django.shortcuts import render, get_object_or_404
from django.http import Http404

import requests
from lxml import etree
from django.conf import settings

from django.shortcuts import render
from django.utils import translation
from django.http import HttpResponse

from django.utils.http import urlencode
from urllib.parse import quote

import json

from alvin_viewer.services.text_collector import get_item_dict

ITEMS_DICT = get_item_dict()

# API host
api_host = settings.API_HOST

# Getting the authority records for navigation of search results

def get_locations(request):
    xml_headers_list = {'Content-Type':'application/vnd.cora.recordList+xml','Accept':'application/vnd.cora.recordList+xml'}

    list_url = f'{api_host}/rest/record/alvin-location'

    response = requests.get(list_url, headers=xml_headers_list)

    if response.status_code == 200: 
        xml_list = etree.fromstring(response.content)       
        locations = []
        for location in xml_list.findall('data/record/data/location'):
            locations.append({
                'identifier': location.findtext('./recordInfo/id'),
                'nameone': location.findtext('./authority[1]/name/namePart[1]'),
                }) 
  
    else:
        raise Http404("Record not found")  
        
    return locations

def get_persons(request):
    if request.GET.get('person'):
        xml_headers_list = {'Content-Type':'application/vnd.cora.record+xml','Accept':'application/vnd.cora.record+xml'}
        person_id = request.GET.get('person') 
        list_url = f'{api_host}/rest/record/alvin-person/{person_id}'

        response = requests.get(list_url, headers=xml_headers_list)
   
        if response.status_code == 200: 
            xml_list = etree.fromstring(response.content)       
            persons = []
            for person in xml_list.findall('./data/person'):
                persons.append({
                    'namegiven': person.findtext('./authority[1]/name/namePart[@type = \'given\']',None),
                    'namenumeration': person.findtext('./authority[1]/name/namePart[@type = \'numeration\']',None),
                    'namefamily': person.findtext('./authority[1]/name/namePart[@type = \'family\']',None),
                    }) 

        else:
            persons = {
                "namegiven": None,
                "namenumeration": None,
                "namefamily": None,
            }
        
        return persons

def get_organisations(request):
    if request.GET.get('organisation'):
        xml_headers_list = {'Content-Type':'application/vnd.cora.record+xml','Accept':'application/vnd.cora.record+xml'}
        organisation_id = request.GET.get('organisation') 
        list_url = f'{api_host}/rest/record/alvin-organisation/{organisation_id}'

        response = requests.get(list_url, headers=xml_headers_list)
   
        if response.status_code == 200: 
            xml_list = etree.fromstring(response.content)       
            organisations = []
            for organisation in xml_list.findall('./data/organisation'):
                organisations.append({
                    'name': organisation.findtext('./authority[1]/name/namePart[1]',None),
                    }) 

        else:
            organisations = {
                "name": None,
            }
        
        return organisations

def get_places(request):
    if request.GET.get('place'):
        xml_headers_list = {'Content-Type':'application/vnd.cora.record+xml','Accept':'application/vnd.cora.record+xml'}
        place_id = request.GET.get('place') 
        list_url = f'{api_host}/rest/record/alvin-place/{place_id}'

        response = requests.get(list_url, headers=xml_headers_list)
   
        if response.status_code == 200: 
            xml_list = etree.fromstring(response.content)       
            places = []
            for place in xml_list.findall('./data/place'):
                places.append({
                    'name': place.findtext('./authority[1]/geographic',None),
                    }) 

        else:
            places = {
                "name": None,
            }
        
        return places

def get_works(request):
    if request.GET.get('work'):
        xml_headers_list = {'Content-Type':'application/vnd.cora.record+xml','Accept':'application/vnd.cora.record+xml'}
        work_id = request.GET.get('work') 
        list_url = f'{api_host}/rest/record/alvin-work/{work_id}'

        response = requests.get(list_url, headers=xml_headers_list)
   
        if response.status_code == 200: 
            xml_list = etree.fromstring(response.content)       
            works = []
            for work in xml_list.findall('./data/work'):
                works.append({
                    'title': work.findtext('./title/mainTitle',None),
                    }) 

        else:
            works = {
                "title": None,
            }
        
        return works

# Getting the lists for search filters and sort them by display language en/no/sv

def get_resourceTypes(request):
    # Original dictionary
    data = ITEMS_DICT.get('typeOfResourceCollection')

    if not data:
        raise Http404("No list found.")
    
    # 1. Get the current active language code (e.g., 'sv', 'en', 'no')
    current_lang = translation.get_language()
    
    # Fallback to 'en' (or your default) if the user's language is not in your dict keys
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'
    
    # 2. Sort the items dynamically based on the translated string value
    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    resourceTypes = sorted_data

    # 3. Pass the sorted dictionary to search
    return resourceTypes

def get_productions(request):
    data = ITEMS_DICT.get('productionMethodCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    productions = sorted_data

    return productions

def get_languages(request):
    data = ITEMS_DICT.get('languageCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    languages = sorted_data

    return languages

def get_countries(request):
    data = ITEMS_DICT.get('countryCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    countries = sorted_data

    return countries

def get_historicalCountries(request):
    data = ITEMS_DICT.get('historicalCountryCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    historicalCountries = sorted_data

    return historicalCountries

def get_genres(request):
    data = ITEMS_DICT.get('genreCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    genres = sorted_data

    return genres

def get_techniques(request):
    data = ITEMS_DICT.get('appliedMaterialCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    techniques = sorted_data

    return techniques

def get_materials(request):
    data = ITEMS_DICT.get('baseMaterialCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    materials = sorted_data

    return materials

def get_subcollections(request):
    data = ITEMS_DICT.get('subcollectionCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    subcollections = sorted_data

    return subcollections

def get_roles(request):
    data = ITEMS_DICT.get('roleCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    roles = sorted_data

    return roles

def get_rights(request):
    data = ITEMS_DICT.get('rightsCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    rights = sorted_data

    return rights

def get_forms(request):
    data = ITEMS_DICT.get('formOfWorkCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    forms = sorted_data

    return forms

def get_genders(request):
    data = ITEMS_DICT.get('genderCollection')

    if not data:
        raise Http404("No list found.")

    current_lang = translation.get_language()
    
    available_langs = ['sv', 'en', 'no']
    if current_lang not in available_langs:
        current_lang = 'sv'

    sorted_data = dict(
        sorted(
            data.items(), 
            key=lambda item: item[1].get(current_lang, '').strip()
        )
    )
    
    genders = sorted_data

    return genders

# Search from REST-API

def alvin_search(request):
    xml_headers_list = {'Content-Type':'application/vnd.cora.recordList-decorated+xml','Accept':'application/vnd.cora.recordList-decorated+xml'}

# Setting all params

    searchType = request.GET.get('searchType', 'alvinRecord')
    query = request.GET.get('query', '**').strip()  
    if query == '':
        query = '**' 
    json_safe_str = json.dumps(query) 
    person = request.GET.get('person', '').strip()
    organisation = request.GET.get('organisation', '').strip()
    place = request.GET.get('place', '').strip()
    work = request.GET.get('work', '').strip()
    location = request.GET.get('location', '').strip()
    type = request.GET.get('type', '').strip()
    production = request.GET.get('production', '').strip()
    genre = request.GET.get('genre', '').strip()
    subject = request.GET.get('subject', '').strip()
    language = request.GET.get('language', '').strip()
    country = request.GET.get('country', '').strip()
    historical = request.GET.get('historical', '').strip()
    technique = request.GET.get('technique', '').strip()
    material = request.GET.get('material', '').strip()
    right = request.GET.get('right', '').strip()
    form = request.GET.get('form', '').strip()
    title = request.GET.get('title', '').strip()
    name = request.GET.get('name', '').strip()
    year = request.GET.get('year', '').strip()
    subcollection = request.GET.get('subcollection', '').strip() 
    occupation = request.GET.get('occupation', '').strip() 
    gender = request.GET.get('gender', '').strip() 
    identifier = request.GET.get('identifier', '').strip()
    shelfmark = request.GET.get('shelfmark', '').strip()
    publication = request.GET.get('publication', '').strip() 
    role = request.GET.get('role', '').strip() 
    collection = request.GET.get('collection', '').strip()  
    digital = request.GET.get('digital', '').strip()     
    id = request.GET.get('id', '').strip() 
    current_lang = translation.get_language()
    lang = request.LANGUAGE_CODE

# Getting all lists
    
    locations = get_locations(request)
    resourceTypes = get_resourceTypes(request)
    productions = get_productions(request)
    genres = get_genres(request)
    techniques = get_techniques(request)
    materials = get_materials(request)
    rights = get_rights(request)
    forms = get_forms(request)
    languages = get_languages(request)
    countries = get_countries(request)
    historicalCountries = get_historicalCountries(request)
    persons = get_persons(request)
    organisations = get_organisations(request)
    places = get_places(request)
    works = get_works(request)
    subcollections = get_subcollections(request)
    roles = get_roles(request)
    genders = get_genders(request)

# Creating normal get search params from Cora params, depending on searchType

# Shared params

    if id != '':
        placeRecordIdSearchTerm = f',{{"name":"placeRecordIdSearchTerm","value":"{id}"}}'  
        organisationRecordIdSearchTerm = f',{{"name":"organisationRecordIdSearchTerm","value":"{id}"}}' 
        personRecordIdSearchTerm = f',{{"name":"personRecordIdSearchTerm","value":"{id}"}}'
        alvinRecordIdSearchTerm = f',{{"name":"alvinRecordIdSearchTerm","value":"{id}"}}'
        workRecordIdSearchTerm = f',{{"name":"workRecordIdSearchTerm","value":"{id}"}}'

    else:  
        placeRecordIdSearchTerm = ''
        organisationRecordIdSearchTerm = ''
        personRecordIdSearchTerm = ''
        alvinRecordIdSearchTerm = ''
        workRecordIdSearchTerm = ''

    if country != '':
        countryCodeSearchTerm = f',{{"name":"countryCodeSearchTerm","value":"{country}"}}'
        placeCountrySearchTerm = f',{{"name":"placeCountrySearchTerm","value":"{country}"}}' 
        organisationCountrySearchTerm = f',{{"name":"organisationCountrySearchTerm","value":"{country}"}}' 
        personNationalitySearchTerm = f',{{"name":"personNationalitySearchTerm","value":"{country}"}}'  
        workCountrySearchTerm = f',{{"name":"workCountrySearchTerm","value":"{country}"}}' 

    else: 
        countryCodeSearchTerm = ''
        placeCountrySearchTerm = ''
        organisationCountrySearchTerm = ''
        personNationalitySearchTerm = ''
        workCountrySearchTerm = '' 

    if place != '':
        placeInRecordSearchTerm = f',{{"name":"placeInRecordSearchTerm","value":"alvin-place_{place}"}}' 
        placeInPersonSearchTerm = f',{{"name":"placeInPersonSearchTerm","value":"alvin-place_{place}"}}' 
    else: 
        placeInRecordSearchTerm = ''
        placeInPersonSearchTerm = ''

    if identifier != '':
        identifierSearchTerm = f',{{"name":"identifierSearchTerm","value":"{identifier}"}}' 
        identifierPersonSearchTerm = f',{{"name":"identifierPersonSearchTerm","value":"{identifier}"}}' 
        identifierOrganisationSearchTerm = f',{{"name":"identifierOrganisationSearchTerm","value":"{identifier}"}}' 

    else: 
        identifierSearchTerm = ''
        identifierPersonSearchTerm = ''
        identifierOrganisationSearchTerm = ''

    if title != '':
        alvinRecordTitleSearchTerm = f',{{"name":"alvinRecordTitleSearchTerm","value":"{title}"}}'  
        workTitleSearchTerm = f',{{"name":"workTitleSearchTerm","value":"{title}"}}' 
 
    else:  
        alvinRecordTitleSearchTerm = ''
        workTitleSearchTerm = ''

    if name != '':
        placeNameSearchTerm = f',{{"name":"placeNameSearchTerm","value":"{name}"}}' 
        organisationNameSearchTerm = f',{{"name":"organisationNameSearchTerm","value":"{name}"}}' 
        personNameSearchTerm = f',{{"name":"personNameSearchTerm","value":"{name}"}}' 

    else: 
        placeNameSearchTerm = ''
        organisationNameSearchTerm = ''
        personNameSearchTerm = ''

    if year != '':
        workCreationDateSearchTerm = f',{{"name":"workCreationDateSearchTerm","value":"{year}"}}' 
        yearSearchTerm = f',{{"name":"yearSearchTerm","value":"{year}"}}'
        yearPersonSearchTerm = f',{{"name":"yearPersonSearchTerm","value":"{year}"}}'
        yearOrganisationSearchTerm = f',{{"name":"yearOrganisationSearchTerm","value":"{year}"}}'
    else:  
        workCreationDateSearchTerm = ''
        yearSearchTerm = ''
        yearPersonSearchTerm = ''
        yearOrganisationSearchTerm = ''

# For alvin-record

    if person != '':
        personInRecordSearchTerm = f',{{"name":"personInRecordSearchTerm","value":"alvin-person_{person}"}}' 
    else: 
        personInRecordSearchTerm = ''

    if organisation != '':
        organisationInRecordSearchTerm = f',{{"name":"organisationInRecordSearchTerm","value":"alvin-organisation_{organisation}"}}' 
    else: 
        organisationInRecordSearchTerm = ''

    if work != '':
        workInRecordSearchTerm = f',{{"name":"workInRecordSearchTerm","value":"alvin-work_{work}"}}' 
    else: 
        workInRecordSearchTerm = ''  

    if location != '':
        locationInRecordSearchTerm = f',{{"name":"locationInRecordSearchTerm","value":"alvin-location_{location}"}}' 
    else: 
        locationInRecordSearchTerm = ''

    if type != '':
        alvinRecordTypeSearchTerm = f',{{"name":"alvinRecordTypeSearchTerm","value":"{type}"}}' 
    else: 
        alvinRecordTypeSearchTerm = ''

    if collection == 'yes':
        collectionTypeOfResourceSearchTerm = f',{{"name":"collectionTypeOfResourceSearchTerm","value":"yes"}}' 
    else: 
        collectionTypeOfResourceSearchTerm = ''

    if production != '':
        productionMethodSearchTerm = f',{{"name":"productionMethodSearchTerm","value":"{production}"}}' 
    else: 
        productionMethodSearchTerm = ''

    if language != '':
        languageCodeSearchTerm = f',{{"name":"languageCodeSearchTerm","value":"{language}"}}'

    else: 
        languageCodeSearchTerm = ''

    if historical != '':
        historicalCountrySearchTerm = f',{{"name":"historicalCountrySearchTerm","value":"{historical}"}}'

    else: 
        historicalCountrySearchTerm = ''

    if publication != '':
        publicationSearchTerm = f',{{"name":"publicationSearchTerm","value":"{publication}"}}' 
    else: 
        publicationSearchTerm = ''

    if genre != '':
        genreFormSearchTerm = f',{{"name":"genreFormSearchTerm","value":"{genre}"}}' 
    else: 
        genreFormSearchTerm = ''

    if subject != '':
        subjectSearchTerm = f',{{"name":"subjectSearchTerm","value":"{subject}"}}' 
    else: 
        subjectSearchTerm = ''

    if technique != '':
        appliedMaterialSearchTerm = f',{{"name":"appliedMaterialSearchTerm","value":"{technique}"}}' 
    else: 
        appliedMaterialSearchTerm = ''

    if material != '':
        baseMaterialSearchTerm = f',{{"name":"baseMaterialSearchTerm","value":"{material}"}}' 
    else: 
        baseMaterialSearchTerm = ''

    if role != '':
        relatorCodeSearchTerm = f',{{"name":"relatorCodeSearchTerm","value":"{role}"}}' 
    else: 
        relatorCodeSearchTerm = ''

    if subcollection != '':
       subcollectionSearchTerm = f',{{"name":"subcollectionSearchTerm","value":"{subcollection}"}}' 
    else: 
        subcollectionSearchTerm = ''

    if shelfmark != '':
        shelfmarkSearchTerm = f',{{"name":"shelfmarkSearchTerm","value":"{shelfmark}"}}' 
    else: 
        shelfmarkSearchTerm = ''

    if right != '':
        rightsSearchTerm = f',{{"name":"rightsSearchTerm","value":"{right}"}}' 
    else: 
        rightsSearchTerm = ''

    if digital == 'yes':
        digitalOriginSearchTerm = f',{{"name":"digitalOriginSearchTerm","value":"reformattedDigital"}}' 
    else: 
        digitalOriginSearchTerm = ''

# For alvin-person

    if occupation != '':
        personOccupationSearchTerm = f',{{"name":"personOccupationSearchTerm","value":"{occupation}"}}' 
    else: 
        personOccupationSearchTerm = ''

    if gender != '':
        personSexSearchTerm = f',{{"name":"personSexSearchTerm","value":"{gender}"}}' 
    else: 
        personSexSearchTerm = ''

# For alvin-work

    if form != '':
        workFormOfWorkSearchTerm = f',{{"name":"workFormOfWorkSearchTerm","value":"{form}"}}' 
    else: 
        workFormOfWorkSearchTerm = ''

# Params for pagination and prev/next/back links

    start = request.GET.get('start', 1)
    if start == '':
        start = 1         
    rows = request.GET.get('rows', 20)
    startnum = int(start)
    rowsnum = int(rows)
    newstart = startnum + rowsnum
    newstartnum = int(newstart)
    view = request.GET.get('view', 'list') 
    params = request.GET.copy()  # make a mutable copy
    params.pop('view', None)  # remove the parameter if it exists
    params.pop('start', None)  # remove the parameter if it exists
    view_url = f"{request.path}?{params.urlencode()}" if params else request.path

# Creating Cora searchData for each recordType

    personSearchData = f'{{"name":"personSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"personSearchTerm","value":{json_safe_str}}}{personNameSearchTerm}{personNationalitySearchTerm}{personRecordIdSearchTerm}{yearPersonSearchTerm}{placeInPersonSearchTerm}{personOccupationSearchTerm}{personSexSearchTerm}{identifierPersonSearchTerm}]}}]}}'
    
    organisationSearchData = f'{{"name":"organisationSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"organisationSearchTerm","value":{json_safe_str}}}{organisationNameSearchTerm}{organisationRecordIdSearchTerm}{organisationCountrySearchTerm}{identifierOrganisationSearchTerm}{yearOrganisationSearchTerm}]}}]}}'

    placeSearchData = f'{{"name":"placeSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"placeSearchTerm","value":{json_safe_str}}}{placeCountrySearchTerm}{placeNameSearchTerm}{placeRecordIdSearchTerm}]}}]}}'

    workSearchData = f'{{"name":"workSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"workSearchTerm","value":{json_safe_str}}}{workFormOfWorkSearchTerm}{workTitleSearchTerm}{workCreationDateSearchTerm}{workRecordIdSearchTerm}{workCountrySearchTerm}]}}]}}'

    alvinRecordSearchData = f'{{"name":"alvinRecordSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"alvinRecordSearchTerm","value":{json_safe_str}}}{locationInRecordSearchTerm}{personInRecordSearchTerm}{organisationInRecordSearchTerm}{placeInRecordSearchTerm}{workInRecordSearchTerm}{alvinRecordIdSearchTerm}{subjectSearchTerm}{alvinRecordTypeSearchTerm}{productionMethodSearchTerm}{genreFormSearchTerm}{appliedMaterialSearchTerm}{baseMaterialSearchTerm}{rightsSearchTerm}{alvinRecordTitleSearchTerm}{countryCodeSearchTerm}{yearSearchTerm}{subcollectionSearchTerm}{languageCodeSearchTerm}{historicalCountrySearchTerm}{identifierSearchTerm}{shelfmarkSearchTerm}{publicationSearchTerm}{relatorCodeSearchTerm}{collectionTypeOfResourceSearchTerm}{digitalOriginSearchTerm},{{"name":"visibilityAlvinSearchTerm","value":"published"}}]}}]}}'

# Creating REST-API request by searchType/recordType

    if searchType == 'alvinRecord':
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={alvinRecordSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'

    elif searchType == 'person':
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={personSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'
  
    elif searchType == 'organisation':
       list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={organisationSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'

    elif searchType == 'work':
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={workSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'

    elif searchType == 'place':
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={placeSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'
       
    else:
        raise Http404("Invalid search") 
   
    response = requests.get(list_url, headers=xml_headers_list)
 
# Getting results for list of hits by searchType/recordType
   
    if response.status_code == 200:
        xml_list = etree.fromstring(response.content)         
        records = []
        if searchType == 'alvinRecord':
            for record in xml_list.findall('data/record/data/record'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'title': record.findtext('./title/mainTitle'),
                    'subtitle': record.findtext('./title/subtitle'),
                    'orientationCode': record.findtext('./title/orientationCode'),
                    'namefamily': record.findtext('.agent[1]/person[1]/linkedRecord/person/authority[1]/name/namePart[@type = "family"]'),
                    'namegiven': record.findtext('.agent[1]/person[1]/linkedRecord/person/authority[1]/name/namePart[@type = "given"]'),
                    'namenumeration': record.findtext('.agent[1]/person[1]/linkedRecord/person/authority[1]/name/namePart[@type = "numeration"]'),
                    'nametermsOfAddress': record.findtext('.agent[1]/person[1]/linkedRecord/person/authority[1]/name/namePart[@type = "termsOfAddress"]'),
                    'familyName': record.findtext('.agent[1]/person[1]/linkedRecord/person/authority[1]/name/familyName'),
                    'namefamilytwo': record.findtext('.agent[2]/person[1]/linkedRecord/person/authority[1]/name/namePart[@type = "family"]'),
                    'locationsv': record.findtext('./physicalLocation/heldBy/location/linkedRecord/location/authority[@lang = "swe"]/name/namePart'),
                    'locationen': record.findtext('./physicalLocation/heldBy/location/linkedRecord/location/authority[@lang = "eng"]/name/namePart'),
                    'locationno': record.findtext('./physicalLocation/heldBy/location/linkedRecord/location/authority[@lang = "nor"]/name/namePart'),
                    'shelfmark': record.findtext('./physicalLocation/shelfMark'),
                    'yearone': record.findtext('./originDate/startDate/date/year'),
                    'yeartwo': record.findtext('./originDate/endDate/date/year'),
                    'displaydate': record.findtext('./originDate/displayDate'),
                    'typeofresource': record.findtext('./typeOfResource'),
                    'collection': record.findtext('./collection'),
                    'rights': record.findtext('./fileSection/rights'),
                    'file_count': len(record.findall('.//file/fileLocation/linkedRecord')),
                    'file': record.findtext('./fileSection/fileGroup/file/fileLocation/linkedRecord/binary/thumbnail[1]/thumbnail/linkedRecordId'),
            
                 })

        elif searchType == 'person':
            for record in xml_list.findall('data/record/data/person'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'namefamily': record.findtext('./authority[1]/name/namePart[@type = "family"]'),
                    'namegiven': record.findtext('./authority[1]/name/namePart[@type = "given"]'),
                    'namenumeration': record.findtext('./authority[1]/name/namePart[@type = "numeration"]'),
                    'nametermsOfAddress': record.findtext('./authority[1]/name/namePart[@type = "termsOfAddress"]'),
                    'familyName': record.findtext('./authority[1]/name/familyName'),
                    'birthyear': record.findtext('./personInfo/birthDate/date/year'),
                    'deathyear': record.findtext('./personInfo/deathDate/date/year'),
                    'displaydate': record.findtext('./personInfo/displayDate')
                 })

        elif searchType == 'organisation':
            for record in xml_list.findall('data/record/data/organisation'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'nameone': record.findtext('./authority[1]/name/namePart[1]'),
                    'nametwo': record.findtext('./authority[2]/name/namePart[1]'),
                    'namethree': record.findtext('./authority[3]/name/namePart[1]'),
                    'subnameone': record.findtext('./authority[1]/name/namePart[2]'),
                    'subnametwo': record.findtext('./authority[2]/name/namePart[2]'),
                    'subnamethree': record.findtext('./authority[3]/name/namePart[2]'),
                 })

        elif searchType == 'place':
            for record in xml_list.findall('data/record/data/place'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'nameone': record.findtext('./authority[1]/geographic'),
                    'nametwo': record.findtext('./authority[2]/geographic'),
                    'namethree': record.findtext('./authority[3]/geographic'),
                 })

        elif searchType == 'work':
            for record in xml_list.findall('data/record/data/work'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'title': record.findtext('./title/mainTitle'),
                    'subtitle': record.findtext('./title/subtitle'),
                    'orientationCode': record.findtext('./title/orientationCode'),
                 })

# For pagination

        pages = {
            "fromNo":xml_list.findtext(".//fromNo"),
            "toNo":xml_list.findtext(".//toNo"),
            "totalNo":xml_list.findtext(".//totalNo"),
            }

        totalNo = pages.get("totalNo")          
        completeListSize = int(totalNo)
        toNo = pages.get("toNo")          
        cursor = int(toNo)        
        startnum = int(start)
        rowsnum = int(rows)
        newstart = startnum + rowsnum
        nextstartnum = int(newstart) 
        prevstart = startnum - rowsnum
        prevstartnum = int(prevstart)

# For back to results link

        link = request.get_full_path()
        encoded_link = quote(link, safe='')

    else:
        raise Http404("Invalid search")
  
    context = {
        "searchType":searchType,
        "query":query,
        "language":language,
        "country":country,
        "historical":historical,
        "identifier":identifier,
        "id":id,
        "type":type,
        "production":production,
        "genre":genre,
        "location":location,
        "technique":technique,
        "material":material,
        "right":right,
        "subcollection":subcollection,
        "shelfmark":shelfmark,
        "publication":publication,
        "role":role,  
        "collection":collection,  
        "digital":digital,
        "title":title,
        "name":name,
        "year":year,
        "form":form,
        "person":person,
        "organisation":organisation,
        "place":place,
        "work":work,
        "subject":subject,
        "occupation":occupation,
        "gender":gender,
        "records":records,
        "completeListSize":completeListSize,
        "startnum":startnum,
        "rowsnum":rowsnum,
        "nextstartnum":nextstartnum,
        "prevstartnum":prevstartnum,
        "cursor":cursor,
        "encoded_link":encoded_link,
        "view":view,
        "view_url":view_url,
        "json_safe_str":json_safe_str,
        "api_host":api_host,
        "external_access_url":settings.EXTERNAL_ACCESS_URL,
        "locations":locations,
        "resourceTypes":resourceTypes,
        "productions":productions,
        "genres":genres,
        "techniques":techniques,
        "materials":materials,
        "rights":rights,
        "forms":forms,
        "languages":languages,
        "countries":countries,
        "historicalCountries":historicalCountries,
        "persons":persons,
        "organisations":organisations,
        "places":places,
        "works":works,
        "subcollections":subcollections,
        "roles":roles,
        "genders":genders,
        "lang":lang,
        "current_lang": current_lang,
        }

    return render(request, 'alvin_search/alvin_search.html', context)

