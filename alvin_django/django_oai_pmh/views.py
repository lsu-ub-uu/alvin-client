# Copyright (C) 2018-2025 J. Nathanael Philipp (jnphilipp) <nathanael@philipp.land>
#
# This file is part of django_oai_pmh.
#
# django_oai_pmh is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# django_oai_pmh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with django_oai_pmh. If not, see <http://www.gnu.org/licenses/>.
"""OAI-PMH Django app views."""

from datetime import datetime
#from django.core.paginator import Paginator, EmptyPage
from django.shortcuts import render
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt

from django.conf import settings

from .settings import NUM_PER_PAGE

import requests
from lxml import etree
import urllib.request
from urllib.request import urlopen
parser = etree.XMLParser()

@csrf_exempt
def oai2(request):
    """Handels all OAI-PMH v2 requets.

    For details see https://www.openarchives.org/OAI/openarchivesprotocol.html
    """
    params = request.POST.copy() if request.method == "POST" else request.GET.copy()

    errors = []
    verb = None
    identifier = None
    metadata_prefix = None
    set_spec = None
    from_timestamp = None
    until_timestamp = None
    resumption_token = None

    # API host
    api_host = settings.API_HOST

    if "verb" in params:
        verb = params.pop("verb")[-1]
        if verb == "GetRecord":
            template = "django_oai_pmh/getrecord.xml"
            xml_headers_list = {'Content-Type':'application/vnd.cora.record-decorated+xml','Accept':'application/vnd.cora.record-decorated+xml'}
            if "metadataPrefix" in params:
                metadata_prefix = params.pop("metadataPrefix")
                if len(metadata_prefix) == 1:
                    metadata_prefix = metadata_prefix[0]
                    prefix_url = f'{api_host}/rest/record/metadata/{metadata_prefix}Item'
                    response = requests.get(prefix_url)
                    if response.status_code != 200:
                        errors.append(
                            _error("cannotDisseminateFormat", metadata_prefix)
                        )
                    if "identifier" in params:
                        identifier = request.GET.get('identifier', '')
                        recordId = identifier.split("org:")
                        record = str(recordId[1])
                        if record.isdigit():
                            record_url =f'{api_host}/rest/record/alvin-record/{record}'
                            if metadata_prefix == 'alvin_xml':
                                response = requests.get(record_url)
                            else:
                                response = requests.get(record_url, headers=xml_headers_list)
                        else:
                            errors.append(_error("idDoesNotExist", identifier))                                                 
                        if response.status_code == 200:
                            xml_record = etree.fromstring(response.content) 
                            
                            if metadata_prefix == 'alvin_xml':

                                with urlopen('http://127.0.0.1:8000/static/xsl/metadata-alvin_xml.xsl') as f:
                                  xslt_tree = etree.parse(f, parser)
                                  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
                                  metadataalvin_xml = transform(xml_record)	# Transform source XML tree

                            
                            else:

                                with urlopen('http://127.0.0.1:8000/static/xsl/metadata-oai_dc.xsl') as f:
                                  xslt_tree = etree.parse(f, parser)
                                  transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
                                  metadataoai_dc = transform(xml_record)	# Transform source XML tree


                        if response.status_code != 200:
                            errors.append(_error("idDoesNotExist", identifier))
                    else:
                        errors.append(_error("badArgument", "identifier"))
                else:
                    errors.append(
                        _error("badArgument_single", ";".join(metadata_prefix))
                    )
                    metadata_prefix = None
            else:
                errors.append(_error("badArgument", "metadataPrefix"))
            _check_bad_arguments(params, errors)
        elif verb == "Identify":
            template = "django_oai_pmh/identify.xml"
            _check_bad_arguments(params, errors)
        elif verb == "ListIdentifiers":
            template = "django_oai_pmh/listidentifiers.xml"              
            set = request.GET.get('set', '*')
            metadata_prefix = request.GET.get('metadataPrefix')
            start = request.GET.get('start', 1)         
            rows = request.GET.get('rows', 100)
            newstart = start + rows
            if "resumptionToken" in params:  
                resumption_token = request.GET.get('resumptionToken')                   
                if resumption_token != "":
                    rt = request.GET.get('resumptionToken')
                    if "/" in rt:
                        rt_list = rt.split("/")
                        metadataprefix = rt_list[0] 
                        if metadataprefix == "":
                            metadataprefix = ""
                        else:
                            metadataprefix = metadataprefix
                        set = rt_list[1]
                        if set == "":
                           set = "*"
                        else:
                           set = set
                        newstart = rt_list[2]
                        if newstart == "":
                            newstart = 1
                            nextstart= 1
                        else:
                            newstart = newstart
                            num = int(newstart)
                            nextstart = num + 1
                            start = num
                            if metadataprefix != "" and set != "" and nextstart > 2:                     
                                resumptionToken = f"{metadataprefix}/{set}/{nextstart}"
                            else:
                                errors.append(_error("badResumptionToken_resumptionToken"))
                    else:
                        resumptionToken = "//"  
                        errors.append(_error("badResumptionToken_resumptionToken"))                             
                else:
                    resumptionToken = "//"  
                    errors.append(_error("badResumptionToken_resumptionToken"))                                
            list_url = f'{api_host}/rest/record/searchResult/alvinRecordSearch?searchData={{"name":"alvinRecordSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"permissionUnitSearchTerm","value":"permissionUnit_{set}"}}]}}]}},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}'
            response = requests.get(list_url)
            if response.status_code == 200:
                xml_list = etree.fromstring(response.content)         
                records = []
                for record in xml_list.findall('data/record/data/record'):
                    records.append({
                      'identifier': record.findtext('./recordInfo/id'),
                      'datestamp': record.findtext('./recordInfo/updated/tsUpdated[last()]'),
         	      'setSpec': record.findtext('./physicalLocation/heldBy/location/linkedRecordId'),
                       })
            else:
                records = 0
            pages = {
                "fromNo":xml_list.findtext(".//fromNo"),
                "toNo":xml_list.findtext(".//toNo"),
                "totalNo":xml_list.findtext(".//totalNo"),
                }
            totalNo = pages.get("totalNo")          
            completeListSize = int(totalNo)
            toNo = pages.get("toNo")          
            cursor = int(toNo) 
            if cursor < completeListSize and not "resumptionToken" in params: 
                metadata_prefix = request.GET.get('metadataPrefix')
                set = request.GET.get('set','')
                newstart = start + rows
                num = int(newstart)
                resumptionToken = f"{metadata_prefix}/{set}/{num}"                
            if "resumptionToken" in params:
                if not records:
                    errors.append(_error("badResumptionToken_resumptionToken"))                        
            elif "metadataPrefix" in params:
                metadata_prefix = params.pop("metadataPrefix")
                if len(metadata_prefix) == 1:
                    metadata_prefix = metadata_prefix[0]
                    prefix_url = f'{api_host}/rest/record/metadata/{metadata_prefix}Item'
                    response = requests.get(prefix_url)
                    if response.status_code != 200:
                        errors.append(
                             _error("cannotDisseminateFormat", metadata_prefix)
                        )
                    else:                      
                        if "set" in params:
                            set_url = f'{api_host}/rest/record/alvin-location/{set}'
                            response = requests.get(set_url)
                            set_spec = params.pop("set")[-1]
                            if response.status_code != 200:
                                errors.append(_error("badArgument_set"))                             
                        from_timestamp, until_timestamp = _check_timestamps(
                            params, errors
                        )
                        if from_timestamp:
                            header_list = header_list.filter(
                                timestamp__gte=from_timestamp
                            )
                        if until_timestamp:
                            header_list = header_list.filter(
                                timestamp__lte=until_timestamp
                            )
                        if not records and not errors:
                            errors.append(_error("noRecordsMatch"))
                else:
                    errors.append(
                        _error("badArgument_single", ";".join(metadata_prefix))
                    )
                    metadata_prefix = None
            else:
               errors.append(_error("badArgument", "metadataPrefix"))
            _check_bad_arguments(params, errors)
        elif verb == "ListMetadataFormats":
            template = "django_oai_pmh/listmetadataformats.xml"

            xml_headers_list = {'Content-Type':'application/vnd.cora.record-decorated+xml','Accept':'application/vnd.cora.record-decorated+xml'}

            list_url = f'{api_host}/rest/record/metadata/metadataFormatCollection'
            response = requests.get(list_url, headers=xml_headers_list)

            if response.status_code == 200:
                xml_list = etree.fromstring(response.content)
          
                metadataformats = []
                for metadataformat in xml_list.findall('./data/metadata/collectionItemReferences/ref'):
                    metadataformats.append({
                       'prefix': metadataformat.findtext('./linkedRecord/metadata/nameInData', default='N/A'),
                       'namespace': metadataformat.findtext('./linkedRecord/metadata/textId/linkedRecord/text/textPart[1]/text', default='N/A'),
         	       'schema': metadataformat.findtext('./linkedRecord/metadata/defTextId/linkedRecord/text/textPart[1]/text', default='N/A'),
                    })            

            if "identifier" in params:
                identifier = params.pop("identifier")[-1]
                recordId = identifier.split("org:")
                record_url =f'{api_host}/rest/record/alvin-record/{recordId[1]}'
                response = requests.get(record_url)
                if response.status_code != 200:
                    errors.append(_error("idDoesNotExist", identifier))

            if response.status_code != 200:
                if identifier:
                    errors.append(_error("noMetadataFormats", identifier))
                else:
                    errors.append(_error("noMetadataFormats"))
            _check_bad_arguments(params, errors)
        elif verb == "ListRecords":
            template = "django_oai_pmh/listrecords.xml"
            xml_headers_list = {'Content-Type':'application/vnd.cora.recordList-decorated+xml','Accept':'application/vnd.cora.recordList-decorated+xml'}
            set = request.GET.get('set', '*')
            metadata_prefix = request.GET.get('metadataPrefix')
            metadataprefix = metadata_prefix
            start = request.GET.get('start', 1)         
            rows = request.GET.get('rows', 100)
            newstart = start + rows
            if "resumptionToken" in params:  
                resumption_token = request.GET.get('resumptionToken')                   
                if resumption_token != "":
                    rt = request.GET.get('resumptionToken')
                    if "/" in rt:
                        rt_list = rt.split("/")
                        metadataprefix = rt_list[0] 
                        if metadataprefix == "":
                            metadataprefix = ""
                        else:
                            metadataprefix = metadataprefix
                        set = rt_list[1]
                        if set == "":
                           set = "*"
                        else:
                           set = set
                        newstart = rt_list[2]
                        if not newstart.isdigit():
                            errors.append(_error("badResumptionToken_resumptionToken"))
                        else:
                            newstart = newstart
                            num = int(newstart)
                            nextstart = num + 1
                            start = num
                            if metadataprefix != "" and set != "" and nextstart > 2:                     
                                resumptionToken = f"{metadataprefix}/{set}/{nextstart}"
                            else:
                                errors.append(_error("badResumptionToken_resumptionToken"))
                    else:
                        resumptionToken = "//"  
                        errors.append(_error("badResumptionToken_resumptionToken"))                             
                else:
                    resumptionToken = "//"  
                    errors.append(_error("badResumptionToken_resumptionToken"))  
                              
            list_url = f'{api_host}/rest/record/searchResult/alvinRecordSearch?searchData={{"name":"alvinRecordSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"permissionUnitSearchTerm","value":"permissionUnit_{set}"}}]}}]}},{{"name":"start","value":"{start}"}},{{"name":"rows","value":"{rows}"}}]}}'

            if metadataprefix == 'alvin_xml':
                response = requests.get(list_url)
            else:
                response = requests.get(list_url, headers=xml_headers_list)

            if response.status_code == 200:
                xml_list = etree.fromstring(response.content)         
                records = []
                for record in xml_list.findall('data/record/data/record'):
                    records.append({
                      'identifier': record.findtext('./recordInfo/id'),
                      'datestamp': record.findtext('./recordInfo/updated/tsUpdated[last()]'),
         	      'setSpec': record.findtext('./physicalLocation/heldBy/location/linkedRecordId'),
                       })

                if metadataprefix == 'alvin_xml':

                    with urlopen('http://127.0.0.1:8000/static/xsl/metadata-alvin_xml.xsl') as f:
                        xslt_tree = etree.parse(f, parser)
                        transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
                        metadataalvin_xml = transform(xml_list)	# Transform source XML tree
                            
                else:

                    with urlopen('http://127.0.0.1:8000/static/xsl/metadata-oai_dc.xsl') as f:
                        xslt_tree = etree.parse(f, parser)
                        transform = etree.XSLT(xslt_tree)     	# Create the XSLT transformer
                        metadataoai_dc = transform(xml_list)	# Transform source XML tree

                pages = {
                    "fromNo":xml_list.findtext(".//fromNo"),
                    "toNo":xml_list.findtext(".//toNo"),
                    "totalNo":xml_list.findtext(".//totalNo"),
                    }
                totalNo = pages.get("totalNo")          
                completeListSize = int(totalNo)
                toNo = pages.get("toNo")          
                cursor = int(toNo) 

                if cursor < completeListSize and not "resumptionToken" in params:  
                    metadata_prefix = request.GET.get('metadataPrefix')
                    set = request.GET.get('set','')
                    newstart = start + rows
                    num = int(newstart)
                    resumptionToken = f"{metadata_prefix}/{set}/{num}"       
  
            else:
                records = 0

            if "resumptionToken" in params:
                if not records:
                    errors.append(_error("badResumptionToken_resumptionToken"))                        
            elif "metadataPrefix" in params:
                metadata_prefix = params.pop("metadataPrefix")
                if len(metadata_prefix) == 1:
                    metadata_prefix = metadata_prefix[0]
                    prefix_url = f'{api_host}/rest/record/metadata/{metadata_prefix}Item'
                    response = requests.get(prefix_url)
                    if response.status_code != 200:
                        errors.append(
                             _error("cannotDisseminateFormat", metadata_prefix)
                        )
                    else:                      
                        if "set" in params:
                            set_url = f'{api_host}/rest/record/alvin-location/{set}'
                            response = requests.get(set_url)
                            set_spec = params.pop("set")[-1]
                            if response.status_code != 200:
                                errors.append(_error("badArgument_set"))                             
                        from_timestamp, until_timestamp = _check_timestamps(
                            params, errors
                        )
                        if from_timestamp:
                            header_list = header_list.filter(
                                timestamp__gte=from_timestamp
                            )
                        if until_timestamp:
                            header_list = header_list.filter(
                                timestamp__lte=until_timestamp
                            )
                        if not records and not errors:
                            errors.append(_error("noRecordsMatch"))
                else:
                    errors.append(
                        _error("badArgument_single", ";".join(metadata_prefix))
                    )
                    metadata_prefix = None
            else:
               errors.append(_error("badArgument", "metadataPrefix"))
            _check_bad_arguments(params, errors)
        elif verb == "ListSets":
            template = "django_oai_pmh/listsets.xml"

            list_url = f'{api_host}/rest/record/searchResult/locationSearch?searchData={{"name":"locationSearch","children":[{{"name":"include","children":[{{"name":"includePart","children":[{{"name":"locationSearchTerm","value":"**"}}]}}]}}]}}'
            response = requests.get(list_url)

            if response.status_code == 200:
                xml_list = etree.fromstring(response.content)

                sets = []
                for set in xml_list.findall('data/record/data/location'):
                    sets.append({
                       'spec': set.findtext('./recordInfo/id', default='N/A'),
                       'name': set.findtext('./authority[1]/name/namePart[1]', default='N/A'),
         	       'description': set.findtext('./authority[1]/name/namePart[1]', default='N/A'),
                    })

            if not sets:
                errors.append(_error("noSetHierarchy"))

            if response.status_code != 200:
                errors.append(_error("noSetHierarchy"))

        else:
            errors.append(_error("badVerb", verb))
    else:
        errors.append(_error("badVerb"))

    return render(
        request,
        template if not errors else "django_oai_pmh/error.xml",
        locals(),
        content_type="text/xml",
    )


def _check_bad_arguments(params, errors, msg=None):
    for k, v in params.copy().items():

        params.pop(k)


def _check_timestamps(params, errors):
    from_timestamp = None
    until_timestamp = None

    granularity = None
    if "from" in params:
        f = params.pop("from")[-1]
        granularity = "%Y-%m-%dT%H:%M:%SZ %z" if "T" in f else "%Y-%m-%d %z"
        try:
            from_timestamp = datetime.strptime(f + " +0000", granularity)
        except Exception:
            errors.append(_error("badArgument_valid", f, "from"))

    if "until" in params:
        u = params.pop("until")[-1]
        ugranularity = "%Y-%m-%dT%H:%M:%SZ %z" if "T" in u else "%Y-%m-%d %z"
        if ugranularity == granularity or not granularity:
            try:
                until_timestamp = datetime.strptime(u + " +0000", granularity)
            except Exception:
                errors.append(_error("badArgument_valid", u, "until"))
        else:
            errors.append(_error("badArgument_granularity"))
    return from_timestamp, until_timestamp

def _error(code, *args):
    if code == "badArgument":
        return {
            "code": "badArgument",
            "msg": f'The required argument "{args[0]}" is missing in the request.',
        }
    elif code == "badArgument_granularity":
        return {
            "code": "badArgument",
            "msg": 'The granularity of the arguments "from" and "until" do not match.',
        }
    elif code == "badArgument_single":
        return {
            "code": "badArgument",
            "msg": "Only a single metadataPrefix argument is allowed, got "
            + f'"{args[0]}".',
        }
    elif code == "badArgument_valid":
        return {
            "code": "badArgument",
            "msg": f'The value "{args[0]}" of the argument "{args[1]}" is not valid.',
        }
    elif code == "badArgument_set":
        return {
            "code": "badArgument",
            "msg": f'Unknown set.',
        }
    elif code == "badResumptionToken_resumptionToken":
        return {
            "code": "badResumptionToken",
            "msg": f'The resumptionToken is illegal.',
        }
    elif code == "badResumptionToken":
        return {
            "code": "badResumptionToken",
            "msg": f'The resumptionToken "{args[0]}" is invalid.',
        }
    elif code == "badResumptionToken_expired":
        return {
            "code": "badResumptionToken",
            "msg": f'The resumptionToken "{args[0]}" is expired.',
        }
    elif code == "badVerb" and len(args) == 0:
        return {"code": "badVerb", "msg": "The request does not provide any verb."}
    elif code == "badVerb":
        return {
            "code": "badVerb",
            "msg": f'The verb "{args[0]}" provided in the request is illegal.',
        }
    elif code == "cannotDisseminateFormat":
        return {
            "code": "cannotDisseminateFormat",
            "msg": f'The value of the metadataPrefix argument "{args[0]}" is not '
            + " supported.",
        }
    elif code == "idDoesNotExist":
        return {
            "code": "idDoesNotExist",
            "msg": f'A record with the identifier "{args[0]}" does not exist.',
        }
    elif code == "noMetadataFormats" and len(args) == 0:
        return {
            "code": "noMetadataFormats",
            "msg": "There are no metadata formats available.",
        }
    elif code == "noMetadataFormats":
        return {
            "code": "noMetadataFormats",
            "msg": "There are no metadata formats available for the record with "
            + f'identifier "{args[0]}".',
        }
    elif code == "noRecordsMatch":
        return {
            "code": "noRecordsMatch",
            "msg": "The combination of the values of the from, until, and set "
            + "arguments results in an empty list.",
        }
    elif code == "noSetHierarchy":
        return {
            "code": "noSetHierarchy",
            "msg": "This repository does not support sets.",
        }
