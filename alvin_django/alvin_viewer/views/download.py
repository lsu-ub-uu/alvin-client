from django.http import Http404, StreamingHttpResponse

import requests
from zipstream import ZipStream

from ..services.alvin_api import AlvinAPI
from ..extractors.record import extract

def download(request, url_type: str, record_id: int):
    
    api = AlvinAPI()
    try:
        root = api.get_record_xml("alvin-record", str(record_id))
        if root is None:
            raise Http404("Record not found")
        metadata = extract(root)
    except Exception:
        raise Http404("Could not fetch record")
    
    file_groups = metadata.files.file_groups if metadata.files else None
    if file_groups is None:
        raise Http404("No files available for download")
    
    files_to_zip = []
    for group in file_groups:
        for file in group.files:
            url = getattr(file, f"{url_type}_url", None)
            if url:
                file_ending = ""
                if url_type == "master":
                    file_ending = file.master_type.split('/')[-1]
                if url_type == "jp2":
                    file_ending = "jp2"
                filename = f"{file.binary_id.replace(':', '_')}.{file_ending}"
                files_to_zip.append({
                    'url': url,
                    'name': filename
                })

    if not files_to_zip:
        raise Http404(f"No files of type '{url_type}' found")

    zs = ZipStream()
    s = requests.Session()

    failed_files = []

    for file_info in files_to_zip:
        try:
            r = s.get(file_info['url'], stream=True)
            
            if not r.ok:
                r.raise_for_status()

            def stream_file(resp=r):
                    for chunk in resp.iter_content(chunk_size=8192):
                        yield chunk
                    resp.close()

        except Exception as e:
            failed_files.append(f"Failed to download file: {file_info['name']}, {e}")
            continue
        
        zs.add(stream_file(), arcname=file_info['name'])
    
    if failed_files:
        log_content = "\n".join(failed_files)
        zs.add(log_content, "error_log.txt")

    response = StreamingHttpResponse(zs, content_type='application/zip')
    response['Content-Disposition'] = f'attachment; filename="{record_id}_{url_type}.zip"'
    
    return response