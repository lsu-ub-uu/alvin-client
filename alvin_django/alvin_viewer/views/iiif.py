import traceback
from django.conf import settings
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
    try:
        debug_log = []
        
        api = AlvinAPI()
        try:
            record_xml = api.get_record_xml("alvin-record", record_id)
        except Exception as e:
            debug_log.append(f"Krasch vid hämtning av post: {str(e)}")
            return JsonResponse({
                "error": "Gick inte att hämta posten från Alvin.",
                "traceback": traceback.format_exc(),
                "debug_log": debug_log
            }, status=500)
        if record_xml is None:
            return JsonResponse({"error": "Record not found.", "debug_log": debug_log}, status=404)

        manifest_base = request.build_absolute_uri(request.path)
        if not manifest_base.endswith("/"):
            manifest_base += "/"

        # Extract record metadata
        record = extract(record_xml)
        main_label = record.main_title.display if record.main_title else None

        canvases = []
        idx = 0

        files = record_xml.xpath("data/record/fileSection/fileGroup/file")
        debug_log.append(f"Hittade {len(files)} filer i posten att iterera över.")

        for f in files:
            file_url = f.findtext("fileLocation/actionLinks/read/url")
            if not file_url:
                debug_log.append("Hoppar över en fil: Saknar read/url.")
                continue
            try:
                    file_xml = api.fetch_file_xml(file_url)
            except Exception as e:
                debug_log.append(f"Kunde inte hämta XML för {file_url}. Fel: {str(e)}")
                continue
            
            if file_xml is None:
                debug_log.append(f"Hoppar över {file_url}: XML-svaret var tomt.")
                continue
            
            binary = file_xml.find("data/binary")
            raw_binary_type = binary.get("type") if binary is not None else None
            binary_type = raw_binary_type.strip().capitalize() if raw_binary_type else None

            # Only build IIIF canvas entries for image binaries
            if binary_type != "Image":
                debug_log.append(f"Hoppar över {file_url}: typ är '{binary_type}', inte 'Image'.")
                continue

            mime_type = file_xml.findtext("data/binary/master/master/mimeType")

            iiif_server = getattr(settings, "EXTERNAL_ACCESS_URL", None)
            ident = file_xml.findtext("otherProtocols/iiif/identifier")

            if not iiif_server or not ident:
                debug_log.append(f"Hoppar över {file_url}: Saknar iiif_server ({iiif_server}) eller identifier ({ident}).")
                continue
                    
            iiif_server = iiif_server.strip()
            ident = ident.strip()

            if not iiif_server.startswith("http"):
                iiif_server = f"https://{iiif_server}"

            image_service_id = f"{iiif_server.rstrip('/')}/{ident.strip('/')}"
            raster_url = f"{image_service_id}/full/max/0/default.jpg"

            idx += 1

            canvas_id = urljoin(manifest_base, f"canvas/{idx}")
            anno_page_id = urljoin(canvas_id + "/", "page")
            anno_id = urljoin(anno_page_id + "/", "anno")
            
            original_url = f.findtext("fileLocation/linkedRecord/binary/jp2/jp2/actionLinks/read/url")
                    
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

            canvas.update(measures)
            canvases.append(canvas)
            debug_log.append(f"Canvas skapad framgångsrikt för {file_url}.")

            if not canvases:
                return JsonResponse({
                    "error": "Inga IIIF-kompatibla filer hittades på denna post.",
                    "debug_log": debug_log
                }, status=404)

        manifest = {
            "@context": "http://iiif.io/api/presentation/3/context.json",
            "id": request.build_absolute_uri(),
            "type": "Manifest",
            "label": {"none": [main_label]},
            "items": canvases,
            "_debug_log": debug_log,
        }
    except Exception as e:
        return JsonResponse({
            "error": "Ett oväntat kodfel inträffade.",
            "exception_message": str(e),
            "traceback": traceback.format_exc(),
            "debug_log": debug_log
        }, status=500)

    return JsonResponse(
        manifest,
        json_dumps_params={"ensure_ascii": False},
    )
