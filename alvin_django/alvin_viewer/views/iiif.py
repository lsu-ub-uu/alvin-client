from django.http import JsonResponse, Http404
from urllib.parse import urljoin
from django.utils.translation import gettext as _
from ..extractors.record import extract
from ..services.alvin_api import AlvinAPI

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
    if record_xml is None:
        raise Http404(_("Record not found."))


    manifest_base = request.build_absolute_uri(request.path)
    if not manifest_base.endswith("/"):
        manifest_base += "/"

    # Extract record metadata
    record = extract(record_xml)
    main_label = record.main_title.display if record.main_title else None

    canvases = []
    idx = 0

    for f in record_xml.xpath("data/record/fileSection/fileGroup/file"):
        try:
            file_xml = api.fetch_file_xml(
                f.findtext("fileLocation/actionLinks/read/url")
            )
        except Exception:
            continue
        if file_xml is None:
            continue
        
        binary = file_xml.find("data/binary")
        raw_binary_type = binary.get("type") if binary is not None else None
        binary_type = raw_binary_type.strip().capitalize() if raw_binary_type else None

        mime_type = file_xml.findtext("data/binary/master/master/mimeType")

        server = file_xml.findtext(".//iiif/server")
        ident = file_xml.findtext(".//iiif/identifier")
        
        # Only build IIIF canvas entries for image binaries.
        if binary_type != "Image":
            continue

        if not server or not ident:
            continue

        server = server.strip()
        ident = ident.strip()

        if not server.startswith("http"):
            server = f"https://{server}"

        print(f"DEBUG IIIF URL: {server}/{ident}")

        image_service_id = f"{server.rstrip('/')}/{ident.strip('/')}"
        raster_url = f"{image_service_id}/full/max/0/default.jpg"

        idx += 1

        canvas_id = urljoin(manifest_base, f"canvas/{idx}")
        anno_page_id = urljoin(canvas_id + "/", "page")
        anno_id = urljoin(anno_page_id + "/", "anno")

        
        original_url = f.findtext("fileLocation/linkedRecord/binary/master/master/actionLinks/read/url")
                
        body = {
            "id": raster_url,
            "type": binary_type,
            "format": mime_type,
            "service": [{
                "id": image_service_id,
                "type": "ImageService2",
                "profile": "http://iiif.io/api/image/2/level2.json"
            }]
        }

        measures = {
                "height": _to_int(file_xml.findtext(".//height"), 1000),
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
                    "format": mime_type,
                    "label": {"none": ["Download original"]},
                }
            ] if original_url else [],
        }

        if binary_type == "Image":
            canvas.update(measures)

        canvases.append(canvas)

    if not canvases:
        raise Http404(_("No IIIF-capable files found on this record."))

    manifest = {
        "@context": "http://iiif.io/api/presentation/3/context.json",
        "id": request.build_absolute_uri(),
        "type": "Manifest",
        "label": {"none": [main_label]} if main_label else {"none": [str(record_id)]},
        "items": canvases,
    }

    return JsonResponse(
        manifest,
        json_dumps_params={"ensure_ascii": False},
    )
