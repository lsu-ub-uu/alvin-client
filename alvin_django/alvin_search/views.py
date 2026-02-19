from django.shortcuts import render, get_object_or_404
from django.http import Http404

import requests
from lxml import etree
from django.conf import settings

from django.shortcuts import render
from django.http import HttpResponse

from django.utils.http import urlencode
from urllib.parse import quote

import json

def alvin_search(request):
    xml_headers_list = {'Content-Type':'application/vnd.cora.recordList-decorated+xml','Accept':'application/vnd.cora.recordList-decorated+xml'}

    searchType = request.GET.get('searchType', 'alvinRecord')
    query = request.GET.get('query', '**')  
    if query == '':
        query = '**' 
    json_safe_str = json.dumps(query) 
    person = request.GET.get('person', '')
    organisation = request.GET.get('organisation', '')
    place = request.GET.get('place', '')
    work = request.GET.get('work', '')
    location = request.GET.get('location', '')
    country = request.GET.get('country', '')
    id = request.GET.get('id', '') 

    if id != '':
        placeRecordIdSearchTerm = f',{{"name":"placeRecordIdSearchTerm","value":"{id}"}}'  
        organisationRecordIdSearchTerm = f',{{"name":"organisationRecordIdSearchTerm","value":"{id}"}}' 
        personRecordIdSearchTerm = f',{{"name":"personRecordIdSearchTerm","value":"{id}"}}'
        alvinRecordIdSearchTerm = f',{{"name":"alvinRecordIdSearchTerm","value":"{id}"}}'


    else:  
        placeRecordIdSearchTerm = ''
        organisationRecordIdSearchTerm = ''
        personRecordIdSearchTerm = ''
        alvinRecordIdSearchTerm = ''
 
    if country != '':
        placeCountrySearchTerm = f',{{"name":"placeCountrySearchTerm","value":"{country}"}}' 
        personNationalitySearchTerm = f',{{"name":"personNationalitySearchTerm","value":"{country}"}}'  
    else:  
        placeCountrySearchTerm = ''
        personNationalitySearchTerm = ''  

    if person != '':
        personInRecordSearchTerm = f',{{"name":"personInRecordSearchTerm","value":"alvin-person_{person}"}}' 
    else: 
        personInRecordSearchTerm = ''

    if organisation != '':
        organisationInRecordSearchTerm = f',{{"name":"organisationInRecordSearchTerm","value":"alvin-organisation_{organisation}"}}' 
    else: 
        organisationInRecordSearchTerm = ''

    if place != '':
        placeInRecordSearchTerm = f',{{"name":"placeInRecordSearchTerm","value":"alvin-place_{place}"}}' 
    else: 
        placeInRecordSearchTerm = ''

    if work != '':
        workInRecordSearchTerm = f',{{"name":"workInRecordSearchTerm","value":"alvin-work_{work}"}}' 
    else: 
        workInRecordSearchTerm = ''   

    if location != '':
        locationInRecordSearchTerm = f',{{"name":"locationInRecordSearchTerm","value":"alvin-location_{location}"}}' 
    else: 
        locationInRecordSearchTerm = ''

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

    personSearchData = f'{{"name":"personSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"personSearchTerm","value":{json_safe_str}}}{personNationalitySearchTerm}{personRecordIdSearchTerm}]}}]}}'
    
    organisationSearchData = f'{{"name":"organisationSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"organisationSearchTerm","value":{json_safe_str}}}{organisationRecordIdSearchTerm}]}}]}}'

    placeSearchData = f'{{"name":"placeSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"placeSearchTerm","value":{json_safe_str}}}{placeCountrySearchTerm}{placeRecordIdSearchTerm}]}}]}}'

    alvinRecordSearchData = f'{{"name":"alvinRecordSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"alvinRecordSearchTerm","value":{json_safe_str}}}{locationInRecordSearchTerm}{personInRecordSearchTerm}{organisationInRecordSearchTerm}{placeInRecordSearchTerm}{workInRecordSearchTerm}{alvinRecordIdSearchTerm},{{"name":"visibilityAlvinSearchTerm","value":"published"}}]}}]}}'
  
     # API host
    api_host = settings.API_HOST

    if searchType == 'alvinRecord':
        #list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={{"name":"{searchType}Search","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"{searchType}SearchTerm","value":{json_safe_str}}}]}}]}},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={alvinRecordSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'

    elif searchType == 'person':
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={personSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'
  
    elif searchType == 'organisation':
       list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={organisationSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'

    elif searchType == 'work':
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={{"name":"{searchType}Search","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"{searchType}SearchTerm","value":{json_safe_str}}}]}}]}},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'

    elif searchType == 'place':
        list_url = f'{api_host}/rest/record/searchResult/{searchType}Search?searchData={placeSearchData},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}&view={view}'
       
    else:
        raise Http404("Invalid search") 
   
    response = requests.get(list_url, headers=xml_headers_list)
    
    if response.status_code == 200:
        xml_list = etree.fromstring(response.content)         
        records = []
        if searchType == 'alvinRecord':
            for record in xml_list.findall('data/record/data/record'):
                records.append({
                    'identifier': record.findtext('./recordInfo/id'),
                    'title': record.findtext('./title/mainTitle'),
                    'subtitle': record.findtext('./title/subtitle'),
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
                    'rights': record.findtext('./fileSection/rights'),
                    'file_count': len(record.findall('.//file')),
                    'file': record.findtext('./fileSection/fileGroup[1]/file[1]/fileLocation/linkedRecordId'),            
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
                 })


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

        link = request.get_full_path()
        encoded_link = quote(link, safe='')

    else:
        raise Http404("Invalid search")
  
    context = {
        "searchType":searchType,
        "query":query,
        "country":country,
        "id":id,
        "location":location,
        "person":person,
        "organisation":organisation,
        "place":place,
        "work":work,
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
        }

    return render(request, 'alvin_search/alvin_search.html', context)

