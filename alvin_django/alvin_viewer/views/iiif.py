from django.http import JsonResponse, Http404
from urllib.parse import urljoin
from django.utils.translation import gettext as _
from ..services.alvin_api import AlvinAPI
from lxml import etree as ET

def _to_int(value, default):
    try:
        return int(value)
    except (TypeError, ValueError):
        return int(default)


def iiif_manifest(request, record_id: str):
    api = AlvinAPI()
    try:
        record_xml = api.get_record_xml("alvin-record", record_id)
    except Exception as e:
        raise Http404(str(e))

    manifest_base = request.build_absolute_uri(request.path)
    if not manifest_base.endswith("/"):
        manifest_base += "/"

    canvases = []
    idx = 0

    for f in record_xml.xpath("data/record/fileSection/fileGroup/file"):
        try:
            file_xml = api.fetch_file_xml(
                f.findtext("fileLocation/actionLinks/read/url")
            )
        except Exception:
            continue
        
        binary = file_xml.find("data/binary")
        binary_type = binary.get("type").capitalize() if binary is not None else None

        format = file_xml.findtext("data/binary/master/master/mimeType")

        server = file_xml.findtext(".//iiif/server")
        ident = file_xml.findtext(".//iiif/identifier")

        if format == "Image":
            if not server or not ident:
                continue
            raster_url = f"{image_service_id}/full/max/0/default.jpg"

        
        image_service_id = f"{server.rstrip('/')}/{ident.strip('/')}"

        idx += 1

        canvas_id = urljoin(manifest_base, f"canvas/{idx}")
        anno_page_id = urljoin(canvas_id + "/", "page")
        anno_id = urljoin(anno_page_id + "/", "anno")

        
        original_url = f.findtext("fileLocation/linkedRecord/binary/master/master/actionLinks/read/url")
                
        body = {
            "id": raster_url,
            "type": binary_type,
            "format": format,
        }

        measures = {
                "heigh": _to_int(file_xml.findtext(".//height"), 1000), 
                "width": _to_int(file_xml.findtext(".//width"), 1000)
                }
        
        if binary_type == "Image":
            body.update(measures) 
        
        canvas = {
            "id": canvas_id,
            "type": "Canvas",
            "items": [
                {
                    "id": anno_page_id,
                    "type": "AnnotationPage",
                    "items": [
                        {
                            "id": anno_id,
                            "type": "Annotation",
                            "motivation": "painting",
                            "target": canvas_id,
                            "body": body,
                        }
                    ],
                }
            ],
            "rendering": [
                {
                    "id": original_url,
                    "type": binary_type,
                    "format": format,
                    "label": {"none": ["Download original"]},
                }
            ] if original_url else [],
        }

        if binary_type == "Image":
            canvas.update(measures)

        print(canvas)

        canvases.append(canvas)

    if not canvases:
        raise Http404(_("No IIIF-capable files found on this record."))

    manifest = {
        "@context": "http://iiif.io/api/presentation/3/context.json",
        "id": request.build_absolute_uri(),
        "type": "Manifest",
        "label": {"none": [f"Record {record_id}"]},
        "items": canvases,
    }

    return JsonResponse(
        manifest,
        json_dumps_params={"ensure_ascii": False},
    )
