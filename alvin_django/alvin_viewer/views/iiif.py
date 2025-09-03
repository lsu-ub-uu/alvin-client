from django.http import JsonResponse, Http404
from urllib.parse import urljoin
from ..services.alvin_api import AlvinAPI

def iiif_manifest(request, record_id: str):
    api = AlvinAPI()
    base_url = request.build_absolute_uri()

    try:
        record_xml = api.get_record_xml("alvin-record", record_id)
    except Exception as e:
        raise Http404(str(e))

    items = []
    for i, f in enumerate(record_xml.xpath("//file"), start=1):
        file_xml = api.fetch_file_xml(f.findtext(".//url"))

        h = int(file_xml.findtext(".//master/height"))
        w = int(file_xml.findtext(".//master/width"))
        server = file_xml.findtext(".//iiif/server")
        ident = file_xml.findtext(".//iiif/identifier")
        image_id = f"{server}/{ident}"

        canvas_id = f"{base_url}canvas/{i}"
        items.append({
            "id": canvas_id,
            "type": "Canvas",
            "height": h,
            "width": w,
            "items": [{
                "id": f"{canvas_id}/page",
                "type": "AnnotationPage",
                "items": [{
                    "id": f"{canvas_id}/page/anno",
                    "type": "Annotation",
                    "motivation": "painting",
                    "body": {
                        "id": f"{image_id}/full/full/0/default.jpg",
                        "type": "Image",
                        "format": "image/jpeg",
                        "height": h,
                        "width": w,
                    },
                }],
            }],
            # "rendering": [{"id": original_url, "type": "Image", "format": "image/jpeg", "label": "Download original image"}]
        })

    manifest = {
        "@context": "http://iiif.io/api/presentation/3/context.json",
        "id": request.build_absolute_uri(),
        "type": "Manifest",
        "items": items,
    }
    return JsonResponse(manifest)