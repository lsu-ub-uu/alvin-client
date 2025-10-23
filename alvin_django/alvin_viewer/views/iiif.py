from django.http import JsonResponse, Http404
from django.views.decorators.cache import cache_page
from django.utils.html import escape
from ..services.alvin_api import AlvinAPI
from lxml import etree

@cache_page(120)
def iiif_manifest(request, record_id: str):
    api = AlvinAPI()
    try:
        record_xml = api.get_record_xml("alvin-record", record_id)        
    except Exception as e:
        raise Http404(str(e))

    items = []
    for i, f in enumerate(record_xml.xpath("//file"), start=1):
        service_id = f.findtext(".//serviceIdentifier")
        w = f.findtext(".//width")
        h = f.findtext(".//height")

        if not service_id:
            continue
        try:
            w = int(w) if w else None
            h = int(h) if h else None
        except ValueError:
            w = h = None

        image_id = f"https://iiif.example.org/iiif/{escape(service_id)}"
        canvas_id = request.build_absolute_uri(f"#canvas-{i}")

        items.append({
            "id": canvas_id,
            "type": "Canvas",
            "height": h or 1000,
            "width": w or 1000,
            "items": [{
                "id": f"{canvas_id}/page/1",
                "type": "AnnotationPage",
                "items": [{
                    "id": f"{canvas_id}/annotation/1",
                    "type": "Annotation",
                    "motivation": "painting",
                    "target": canvas_id,
                    "body": {
                        "id": f"{image_id}/full/max/0/default.jpg",
                        "type": "Image",
                        "format": "image/jpeg",
                        "height": h or 1000,
                        "width": w or 1000,
                    },
                }],
            }],
        })

    manifest = {
        "@context": "http://iiif.io/api/presentation/3/context.json",
        "id": request.build_absolute_uri(),
        "type": "Manifest",
        "items": items,
    }
    return JsonResponse(manifest)