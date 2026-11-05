from django.shortcuts import render, get_object_or_404, redirect
from django.http import Http404, HttpResponse
from django.conf import settings
from django.utils import translation
from django.utils.http import urlencode
from urllib.parse import quote
import json

from services.text_collector import get_item_dict
from services.alvin_api import AlvinAPI

ITEMS_DICT = get_item_dict()

# Initiera API-klienten
api = AlvinAPI()
api_host = settings.API_HOST

# Hämtar endast den fasta listan över arkivinstitutioner (används till select-filtret)
def get_locations() -> list:
    list_url = f'{api_host}/rest/record/alvin-location'
    xml_headers_list = {
        'Content-Type': 'application/vnd.cora.recordList+xml',
        'Accept': 'application/vnd.cora.recordList+xml'
    }
    try:
        # Använd api.session för att behålla samma session/retries men med rätt Accept-header för listor
        resp = api.session.get(list_url, headers=xml_headers_list, timeout=(3, 15))
        resp.raise_for_status()
        xml_list = api._parse_xml(resp.content)
        
        locations = []
        for location in xml_list.findall('data/record/data/location'):
            locations.append({
                'identifier': location.findtext('./recordInfo/id'),
                'nameone': location.findtext('./authority[1]/name/namePart[1]'),
            }) 
    except Exception:
        raise Http404("Locations not found")
        
    return locations

def item_collector(collection: str) -> dict:
    """
    Collect items from metadata collections and sorts them alphabetically

    """
    data = ITEMS_DICT.get(collection)
    if not data:
        raise Http404("No list found.")
    current_lang = translation.get_language()
    if current_lang not in ['sv', 'en', 'no']:
        current_lang = 'sv'
    return dict(sorted(data.items(), key=lambda item: item[1].get(current_lang, '').strip()))

# Genererar aktiva filter (använder ID/värde direkt eller uppslagna samlingar)
def get_active_filters(request, locations, resourceTypes, productions, genres, techniques, materials, rights, forms, languages, countries, historicalCountries, subcollections, roles, genders):
    active_filters = []
    ignored_params = {'searchType', 'view', 'start', 'rows', 'page'}
    
    for key, value in request.GET.items():
        if not value or key in ignored_params:
            continue
            
        if key == 'query' and value == '**':
            continue

        params = request.GET.copy()
        params.pop(key, None)
        remove_url = f"{request.path}?{params.urlencode()}" if params else request.path

        label = value
        prefix = None

        if key == 'person':
            prefix = 'Person'
        elif key == 'organisation':
            prefix = 'Organisation'
        elif key == 'place':
            prefix = 'Plats'
        elif key == 'work':
            prefix = 'Verk'
        elif key == 'id':
            prefix = 'ID'
        elif key == 'digital':
            label = 'Digital version'
        elif key == 'collection':
            label = 'Samlingspost'
        elif key == 'family':
            label = 'Släkt'
        elif key == 'location':
            for loc in locations:
                if loc.get('identifier') == value:
                    label = loc.get('nameone')
                    break
        elif key == 'type' and resourceTypes:
            label = resourceTypes.get(value, {}).get(translation.get_language(), value)
        elif key == 'form' and forms:
            label = forms.get(value, {}).get(translation.get_language(), value)
        elif key == 'production' and productions:
            label = productions.get(value, {}).get(translation.get_language(), value)
        elif key == 'language' and languages:
            label = languages.get(value, {}).get(translation.get_language(), value)
        elif key == 'country' and countries:
            label = countries.get(value, {}).get(translation.get_language(), value)
        elif key == 'historical' and historicalCountries:
            label = historicalCountries.get(value, {}).get(translation.get_language(), value)
        elif key == 'genre' and genres:
            label = genres.get(value, {}).get(translation.get_language(), value)
        elif key == 'technique' and techniques:
            label = techniques.get(value, {}).get(translation.get_language(), value)
        elif key == 'material' and materials:
            label = materials.get(value, {}).get(translation.get_language(), value)
        elif key == 'role' and roles:
            label = roles.get(value, {}).get(translation.get_language(), value)
        elif key == 'subcollection' and subcollections:
            label = subcollections.get(value, {}).get(translation.get_language(), value)
        elif key == 'right' and rights:
            label = rights.get(value, {}).get(translation.get_language(), value)
        elif key == 'gender' and genders:
            label = genders.get(value, {}).get(translation.get_language(), value)

        active_filters.append({
            'key': key,
            'prefix': prefix,
            'label': label,
            'remove_url': remove_url
        })
        
    return active_filters

# Huvudvy för sökning
def alvin_search(request):
    # Städa bort tomma parametrar ur URL:en direkt
    has_empty_params = any(v == '' or (k == 'query' and v == '**') for k, v in request.GET.items())
    if has_empty_params:
        cleaned_params = request.GET.copy()
        for k, v in list(cleaned_params.items()):
            if v == '' or (k == 'query' and v == '**'):
                cleaned_params.pop(k)

        query_string = cleaned_params.urlencode()
        redirect_url = request.path
        if query_string:
            redirect_url += f"?{query_string}"
        return redirect(redirect_url)
    
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
    family = request.GET.get('family', '').strip()  
    identifier = request.GET.get('identifier', '').strip()
    shelfmark = request.GET.get('shelfmark', '').strip()
    publication = request.GET.get('publication', '').strip() 
    role = request.GET.get('role', '').strip() 
    collection = request.GET.get('collection', '').strip()  
    digital = request.GET.get('digital', '').strip()     
    id = request.GET.get('id', '').strip() 
    
    current_lang = translation.get_language()
    lang = request.LANGUAGE_CODE

    # Hämta statiska filterlistor
    locations = get_locations()
    resourceTypes = item_collector("typeOfResourceCollection")
    productions = item_collector("productionMethodCollection")
    genres = item_collector("genreCollection")
    techniques = item_collector("appliedMaterialCollection")
    materials = item_collector("baseMaterialCollection")
    rights = item_collector("rightsCollection")
    forms = item_collector("formOfWorkCollection")
    languages = item_collector("languageCollection")
    countries = item_collector("countryCollection")
    historicalCountries = item_collector("historicalCountryCollection")
    subcollections = item_collector("subcollectionCollection")
    roles = item_collector("roleCollection")
    genders = item_collector("genderCollection")

    # Bygg Cora söktermer
    placeRecordIdSearchTerm = f',{{"name":"placeRecordIdSearchTerm","value":"{id}"}}' if id else ''
    organisationRecordIdSearchTerm = placeRecordIdSearchTerm
    personRecordIdSearchTerm = placeRecordIdSearchTerm
    alvinRecordIdSearchTerm = placeRecordIdSearchTerm
    workRecordIdSearchTerm = placeRecordIdSearchTerm

    countryCodeSearchTerm = f',{{"name":"countryCodeSearchTerm","value":"{country}"}}' if country else ''
    placeCountrySearchTerm = countryCodeSearchTerm
    organisationCountrySearchTerm = countryCodeSearchTerm
    personNationalitySearchTerm = countryCodeSearchTerm
    workCountrySearchTerm = countryCodeSearchTerm

    placeInRecordSearchTerm = f',{{"name":"placeInRecordSearchTerm","value":"alvin-place_{place}"}}' if place else ''
    placeInPersonSearchTerm = placeInRecordSearchTerm

    identifierSearchTerm = f',{{"name":"identifierSearchTerm","value":"{identifier}"}}' if identifier else ''
    identifierPersonSearchTerm = identifierSearchTerm
    identifierOrganisationSearchTerm = identifierSearchTerm

    alvinRecordTitleSearchTerm = f',{{"name":"alvinRecordTitleSearchTerm","value":"{title}"}}' if title else ''
    workTitleSearchTerm = alvinRecordTitleSearchTerm

    placeNameSearchTerm = f',{{"name":"placeNameSearchTerm","value":"{name}"}}' if name else ''
    organisationNameSearchTerm = placeNameSearchTerm
    personNameSearchTerm = placeNameSearchTerm

    yearSearchTerm = f',{{"name":"yearSearchTerm","value":"{year}"}}' if year else ''
    workCreationDateSearchTerm = yearSearchTerm
    yearPersonSearchTerm = yearSearchTerm
    yearOrganisationSearchTerm = yearSearchTerm

    personInRecordSearchTerm = f',{{"name":"personInRecordSearchTerm","value":"alvin-person_{person}"}}' if person else ''
    organisationInRecordSearchTerm = f',{{"name":"organisationInRecordSearchTerm","value":"alvin-organisation_{organisation}"}}' if organisation else ''
    workInRecordSearchTerm = f',{{"name":"workInRecordSearchTerm","value":"alvin-work_{work}"}}' if work else ''  
    locationInRecordSearchTerm = f',{{"name":"locationInRecordSearchTerm","value":"alvin-location_{location}"}}' if location else ''
    alvinRecordTypeSearchTerm = f',{{"name":"alvinRecordTypeSearchTerm","value":"{type}"}}' if type else ''
    collectionTypeOfResourceSearchTerm = f',{{"name":"collectionTypeOfResourceSearchTerm","value":"yes"}}' if collection == 'yes' else ''
    productionMethodSearchTerm = f',{{"name":"productionMethodSearchTerm","value":"{production}"}}' if production else ''
    languageCodeSearchTerm = f',{{"name":"languageCodeSearchTerm","value":"{language}"}}' if language else ''
    historicalCountrySearchTerm = f',{{"name":"historicalCountrySearchTerm","value":"{historical}"}}' if historical else ''
    publicationSearchTerm = f',{{"name":"publicationSearchTerm","value":"{publication}"}}' if publication else ''
    genreFormSearchTerm = f',{{"name":"genreFormSearchTerm","value":"{genre}"}}' if genre else ''
    subjectSearchTerm = f',{{"name":"subjectSearchTerm","value":"{subject}"}}' if subject else ''
    appliedMaterialSearchTerm = f',{{"name":"appliedMaterialSearchTerm","value":"{technique}"}}' if technique else ''
    baseMaterialSearchTerm = f',{{"name":"baseMaterialSearchTerm","value":"{material}"}}' if material else ''
    relatorCodeSearchTerm = f',{{"name":"relatorCodeSearchTerm","value":"{role}"}}' if role else ''
    subcollectionSearchTerm = f',{{"name":"subcollectionSearchTerm","value":"{subcollection}"}}' if subcollection else ''
    shelfmarkSearchTerm = f',{{"name":"shelfmarkSearchTerm","value":"{shelfmark}"}}' if shelfmark else ''
    rightsSearchTerm = f',{{"name":"rightsSearchTerm","value":"{right}"}}' if right else ''
    digitalOriginSearchTerm = f',{{"name":"digitalOriginSearchTerm","value":"reformattedDigital"}}' if digital == 'yes' else ''

    familyNameSearchTerm = f',{{"name":"familyNameSearchTerm","value":"yes"}}' if family == 'yes' else ''
    personOccupationSearchTerm = f',{{"name":"personOccupationSearchTerm","value":"{occupation}"}}' if occupation else ''
    personSexSearchTerm = f',{{"name":"personSexSearchTerm","value":"{gender}"}}' if gender else ''
    workFormOfWorkSearchTerm = f',{{"name":"workFormOfWorkSearchTerm","value":"{form}"}}' if form else ''

    # Paginering
    start = request.GET.get('start', 1)
    if start == '':
        start = 1         
    rows = request.GET.get('rows', 20)
    startnum = int(start)
    rowsnum = int(rows)
    newstart = startnum + rowsnum
    newstartnum = int(newstart)
    view = request.GET.get('view', 'list') 

    params = request.GET.copy()
    params.pop('view', None)
    params.pop('start', None)
    view_url = f"{request.path}?{params.urlencode()}" if params else request.path

    # Skapa Cora searchData JSON
    personSearchData = f'{{"name":"personSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"personSearchTerm","value":{json_safe_str}}}{personNameSearchTerm}{personNationalitySearchTerm}{personRecordIdSearchTerm}{yearPersonSearchTerm}{placeInPersonSearchTerm}{personOccupationSearchTerm}{personSexSearchTerm}{identifierPersonSearchTerm}{familyNameSearchTerm}]}}]}}'
    organisationSearchData = f'{{"name":"organisationSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"organisationSearchTerm","value":{json_safe_str}}}{organisationNameSearchTerm}{organisationRecordIdSearchTerm}{organisationCountrySearchTerm}{identifierOrganisationSearchTerm}{yearOrganisationSearchTerm}]}}]}}'
    placeSearchData = f'{{"name":"placeSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"placeSearchTerm","value":{json_safe_str}}}{placeCountrySearchTerm}{placeNameSearchTerm}{placeRecordIdSearchTerm}]}}]}}'
    workSearchData = f'{{"name":"workSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"workSearchTerm","value":{json_safe_str}}}{workFormOfWorkSearchTerm}{workTitleSearchTerm}{workCreationDateSearchTerm}{workRecordIdSearchTerm}{workCountrySearchTerm}]}}]}}'
    alvinRecordSearchData = f'{{"name":"alvinRecordSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"alvinRecordSearchTerm","value":{json_safe_str}}}{locationInRecordSearchTerm}{personInRecordSearchTerm}{organisationInRecordSearchTerm}{placeInRecordSearchTerm}{workInRecordSearchTerm}{alvinRecordIdSearchTerm}{subjectSearchTerm}{alvinRecordTypeSearchTerm}{productionMethodSearchTerm}{genreFormSearchTerm}{appliedMaterialSearchTerm}{baseMaterialSearchTerm}{rightsSearchTerm}{alvinRecordTitleSearchTerm}{countryCodeSearchTerm}{yearSearchTerm}{subcollectionSearchTerm}{languageCodeSearchTerm}{historicalCountrySearchTerm}{identifierSearchTerm}{shelfmarkSearchTerm}{publicationSearchTerm}{relatorCodeSearchTerm}{collectionTypeOfResourceSearchTerm}{digitalOriginSearchTerm},{{"name":"visibilityAlvinSearchTerm","value":"published"}}]}}]}}'

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
   
    xml_headers_search = {
        'Content-Type': 'application/vnd.cora.recordList-decorated+xml',
        'Accept': 'application/vnd.cora.recordList-decorated+xml'
    }
    try:
        resp = api.session.get(list_url, headers=xml_headers_search, timeout=(3, 15))
        resp.raise_for_status()
        xml_list = api._parse_xml(resp.content)
    except Exception as e:
        raise Http404(f"Invalid search: {e}")
 
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

    pages = {
        "fromNo": xml_list.findtext(".//fromNo"),
        "toNo": xml_list.findtext(".//toNo"),
        "totalNo": xml_list.findtext(".//totalNo"),
    }

    totalNo = pages.get("totalNo") or "0"          
    completeListSize = int(totalNo)
    toNo = pages.get("toNo") or "0"          
    cursor = int(toNo)        
    startnum = int(start)
    rowsnum = int(rows)
    newstart = startnum + rowsnum
    nextstartnum = int(newstart) 
    prevstart = startnum - rowsnum
    prevstartnum = int(prevstart)

    link = request.get_full_path()
    encoded_link = quote(link, safe='')

    active_filters = get_active_filters(
        request, locations, resourceTypes, productions, genres, 
        techniques, materials, rights, forms, languages, countries, 
        historicalCountries, subcollections, roles, genders
    )
  
    context = {
        "searchType": searchType,
        "query": query,
        "language": language,
        "country": country,
        "historical": historical,
        "identifier": identifier,
        "id": id,
        "type": type,
        "production": production,
        "genre": genre,
        "location": location,
        "technique": technique,
        "material": material,
        "right": right,
        "subcollection": subcollection,
        "shelfmark": shelfmark,
        "publication": publication,
        "role": role,  
        "collection": collection,  
        "digital": digital,
        "title": title,
        "name": name,
        "year": year,
        "form": form,
        "person": person,
        "organisation": organisation,
        "place": place,
        "work": work,
        "subject": subject,
        "occupation": occupation,
        "family": family,
        "gender": gender,
        "records": records,
        "completeListSize": completeListSize,
        "startnum": startnum,
        "rowsnum": rowsnum,
        "nextstartnum": nextstartnum,
        "prevstartnum": prevstartnum,
        "cursor": cursor,
        "encoded_link": encoded_link,
        "view": view,
        "view_url": view_url,
        "json_safe_str": json_safe_str,
        "api_host": api_host,
        "external_access_url": settings.EXTERNAL_ACCESS_URL,
        "locations": locations,
        "resourceTypes": resourceTypes,
        "productions": productions,
        "genres": genres,
        "techniques": techniques,
        "materials": materials,
        "rights": rights,
        "forms": forms,
        "languages": languages,
        "countries": countries,
        "historicalCountries": historicalCountries,
        "subcollections": subcollections,
        "roles": roles,
        "genders": genders,
        "lang": lang,
        "current_lang": current_lang,
        "active_filters": active_filters,
    }

    return render(request, 'alvin_search/alvin_search.html', context)
