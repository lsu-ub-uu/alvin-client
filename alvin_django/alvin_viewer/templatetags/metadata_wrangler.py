
from typing import Optional
from django import template
from django.utils.translation import get_language

register = template.Library()

@register.filter
def select_current_language():
    return {'sv':'swe','en':'eng','no':'nor'}.get(get_language(), 'swe')

def _lang(metadata):
    return select_current_language() if metadata.get(select_current_language()) else next(iter(metadata))

@register.filter
def alvin_title(metadata, record_type):

    if record_type in ("alvin-record", "alvin-work"):
        title = metadata.get("main_title")
        return alvin_record_title(title)
    
    if metadata in (None, ""):
        return "Name not found"

    names = (metadata.get("authority_names") or {}).get("names") or metadata
    lang = _lang(names)
    lang_data = names.get(lang, {})
    
    if record_type == "alvin-person":
        return alvin_person_name(lang_data)
    
    if record_type == "alvin-place":
        return alvin_place_name(lang_data)
    
    if record_type == "alvin-organisation":
        return alvin_organisation_name(lang_data)
    
@register.filter
def agent_name(metadata):
    lang = _lang(metadata)
    lang_data = metadata[lang]
    return alvin_person_name(lang_data) if lang_data.get("family_name") else alvin_organisation_name(lang_data)

@register.filter
def alvin_record_title(metadata):
    keys = ["main_title", "subtitle"]
    return " : ".join(filter(None, ((metadata or {}).get(key) for key in keys)))

@register.filter
def alvin_person_name(metadata):
    keys = ["given_name", "family_name", "numeration"]
    def name_join(name):
        n = " ".join(filter(None, (name.get(key) for key in keys)))
        if name.get("terms_of_address"):
            return f"{n}, {name['terms_of_address']}"
        return n
    
    if isinstance(metadata, list):
        return " ; ".join(filter(None, ([name_join(name) for name in metadata])))
    return name_join(metadata)

@register.filter
def alvin_place_name(metadata):
    if isinstance(metadata, list):
        return " ; ".join(filter(None, ([name.get("geographic") for name in metadata])))
    return (metadata or {}).get("geographic")

@register.filter
def alvin_organisation_name(metadata):
    keys = ["corporate_name", "subordinate_name"]
    def name_join(name):
        n = " ; ".join(filter(None, (name.get(key) for key in keys)))
        if name.get("terms_of_address"):
            return f"{n}, {name['terms_of_address']}"
        return n
    if isinstance(metadata, list):
        return " ; ".join(filter(None, ([name_join(name) for name in metadata])))
    return name_join(metadata)

@register.filter
def alvin_work_name(metadata):
    keys = ["main_title", "subtitle"]
    return " : ".join(filter(None, ((metadata or {}).get(key) for key in keys)))

@register.filter
def role_join(metadata):
    return ", ".join(filter(None, metadata))

@register.filter
def list_join(metadata):
    if not isinstance(metadata, list):
        return None

    return ', '.join(filter(None, (metadata)))

@register.filter
def origin_countries(metadata):
    if not isinstance(metadata, dict):
        return ""
    
    keys = ["country", "historical_country"]
    oc = []

    for key in keys:
        cd = metadata.get(key) or {}
        items = cd.get("items")

        if not isinstance(items, list):
            continue
        
        oc.extend(items)

    oc_str = ', '.join(filter(None, (oc)))
    if oc_str in (None, ""):
        return ""
    return f", {oc_str}"

@register.filter
def date_join(metadata):
    if not isinstance(metadata, dict):
        return ""
    
    keys = ["year", "month", "day"]
    d = []

    for key in keys:
        item = (metadata or {}).get(key) or {}
        d.append(item)
    
    date = "-".join(filter(None, (d)))
    era = (metadata or {}).get("era")

    return f"{date} {era}" if era is not None else date

@register.filter
def dates_join(metadata):
    if not isinstance(metadata, dict):
        return None

    start_date = metadata.get("start_date") or {}
    end_date = metadata.get("end_date") or {}

    joined_start = date_join(start_date)
    joined_end = date_join(end_date)

    joined_date = " – ".join(filter(None, (joined_start, joined_end)))
    return " ".join(filter(None, [joined_date, (metadata or {}).get("date_note")])) if joined_date.endswith(".") else " ".join(filter(None, [joined_date, (metadata or {}).get("date_note")])) 

@register.filter
def dimensions_join(metadata):
    keys = ["height", "width", "depth", "diameter"]

    parts = []

    for key in keys:
        item = (metadata or {}).get(key) or {}
        text = item.get("text")
        label = item.get("label")

        if text not in (None, "") and label not in (None, ""):
            joined = f"{text} ({label})"
            parts.append(str(joined))

    parts_str = " x ".join(filter(None,parts))
    unit_str = metadata.get("unit") or None
    return " ".join(filter(None, (parts_str, unit_str))).lower()

@register.filter
def measure_join(metadata):
    keys = ["weight", "unit"]

    m = []

    for key in keys:
        item = (metadata or {}).get(key) or {}
        m.append(item)
    
    return " ".join(filter(None, (m)))

@register.filter
def subjects_join(metadata):
    keys = ["topic", "genreForm", "geographicCoverage", "temporal", "occupation"]
    return ", ".join(filter(None, ((metadata or {}).get(key) for key in keys)))

@register.filter
def part_join(metadata):
    if not isinstance(metadata, dict):
        return ""
    
    keys = ["number", "extent"]
    return ", ".join(filter(None, ((metadata or {}).get(key) for key in keys)))

@register.filter
def item_description_join(metadata):
    keys = ["item", "text"]
    return ". ".join(filter(None, ((metadata or {}).get(key) for key in keys)))

@register.filter
def label_join(metadata: Optional[dict], element: str) -> str:
    if not isinstance(metadata, dict):
        return ""
    l = metadata.get("label")
    sub = metadata.get(element)
    el = (sub.get("label") if isinstance(sub, dict) else sub) if sub else None
    result = ", ".join(filter(None, (l, el)))
    return result.capitalize() if result else ""

@register.filter
def appraisal_join(metadata: Optional[dict]):
    if not isinstance(metadata, dict):
        return ""
    keys = ["value", "currency"]
    return " ".join(filter(None, ((metadata or {}).get(key) for key in keys)))