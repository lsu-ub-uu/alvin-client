from collections.abc import Mapping, Sequence

def clean_empty(md):

    if isinstance(md, Mapping):
        cleaned = {
            k: clean_empty(v)
            for k, v in md.items()
            if v not in (None, "", [], {})
        }
        return {k: v for k, v in cleaned.items() if v not in (None, "", [], {})}
    
    elif isinstance(md, Sequence) and not isinstance(md, (str, bytes, bytearray)):
        cleaned_list = [clean_empty(v) for v in md]
        return [v for v in cleaned_list if v not in (None, "", [], {})]

    else:
        return md