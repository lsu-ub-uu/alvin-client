from collections.abc import Mapping, Sequence

def clean_empty(metadata):

    if isinstance(metadata, Mapping):
        cleaned = {
            k: clean_empty(v)
            for k, v in metadata.items()
            if v not in (None, "", [], {})
        }
        return {k: v for k, v in cleaned.items() if v not in (None, "", [], {})}
    
    elif isinstance(metadata, Sequence) and not isinstance(metadata, (str, bytes, bytearray)):
        cleaned_list = [clean_empty(v) for v in metadata]
        return [v for v in cleaned_list if v not in (None, "", [], {})]

    else:
        return metadata