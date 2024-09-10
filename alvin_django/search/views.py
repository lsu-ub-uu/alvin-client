from django.shortcuts import render
from django.core.paginator import Paginator
from django.http import JsonResponse
import requests

# Create your views here.
def search_result(request):
    
    # List headers
    json_headers_list = {'Content-Type':'application/vnd.uub.recordList+json','Accept':'application/vnd.uub.recordList+json'}

    # För previewmiljön
    preview_place_list_base_url = 'https://cora.epc.ub.uu.se/alvin/rest/record/searchResult/placeSearch?searchData={"name":"placeSearch","children":[{"name":"include","children":[{"name":"includePart","children":[{"name":"placeSearchTerm","value":"**"}]}]}]}'
    
    # För devmiljön
    # place_url = 'http://130.238.171.238:38081/alvin/rest/record/alvin-place'
    # record_url = 'http://130.238.171.238:38081/alvin/rest/record/test'

    data = requests.get(preview_place_list_base_url, headers=json_headers_list)   

    return JsonResponse(data)

def search(request):
    
    # List headers
    json_headers_list = {'Content-Type':'application/vnd.uub.recordList+json','Accept':'application/vnd.uub.recordList+json'}

    # För previewmiljön
    preview_place_list_base_url = 'https://cora.epc.ub.uu.se/alvin/rest/record/searchResult/placeSearch?searchData={"name":"placeSearch","children":[{"name":"include","children":[{"name":"includePart","children":[{"name":"placeSearchTerm","value":"**"}]}]}]}'
    
    # För devmiljön
    # place_url = 'http://130.238.171.238:38081/alvin/rest/record/alvin-place'
    # record_url = 'http://130.238.171.238:38081/alvin/rest/record/test'
    try:
        # Make a GET request to the external API
        response = requests.get(preview_place_list_base_url, headers=json_headers_list)
        response.raise_for_status()  # Raise an exception for HTTP errors
        data = response.json()  # Parse the JSON response

        # Extracting relevant data from the JSON
        data_list = data.get('dataList', {})
        records = data_list.get('data', [])

        # Context to pass to the template
        context = {
            'data':data,
            'records': records,
        }
        
        # Render the template with the data
        return render(request, 'search/search.html', context)
        
    except requests.RequestException as e:
        # Handle any errors that occur during the request
        return JsonResponse({'error': str(e)}, status=500)