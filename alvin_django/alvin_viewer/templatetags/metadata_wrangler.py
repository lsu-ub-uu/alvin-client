from django import template
from django.utils.translation import get_language

register = template.Library()

@register.filter
def select_current_language():
    lang_options = {
        'sv': 'swe',
        'en': 'eng',
        'no': 'nor'
        }
    
    return lang_options[get_language()]

def _lang(metadata):
    return select_current_language() if metadata.get(select_current_language()) else next(iter(metadata))

@register.filter
def alvin_title(metadata, record_type):
    
    title = (metadata.get("authority_names")
             if record_type in {"alvin-place", "alvin-person", "alvin-organisation"}
             else metadata.get("main_title"))
    
    mapping = {
        "alvin-place": (None, None),
        "alvin-person": (" ", ["given_name", "family_name", "numeration"]),
        "alvin-organisation": (". ", ["corporate_name", "subordinate_name"]),
        "alvin-work": (" : ", ["main_title", "subtitle"]),
        "alvin-record": (" : ", ["main_title", "subtitle"]),
    }
    
    if record_type not in mapping:
        raise ValueError("Record type is not valid")
    
    joiner, keys = mapping[record_type]

    # Geographic på valt språk
    if record_type == "alvin-place":
        lang = _lang(title)
        return title.get(lang, {}).get("geographic", "")
    
    # För alvin-person och alvin-organisation, join baserad på valt språk
    if record_type in {"alvin-person", "alvin-organisation"}:
        lang = _lang(title)
        lang_data = title.get(lang, {})
        title_part = joiner.join(filter(None, (lang_data.get(key) for key in keys)))
        if record_type == "alvin-person":
            term = lang_data.get("terms_of_address")
            # Om term exists, inkludera denna; annars returneras enbart title_part.
            return f"{title_part}, {term}" if term and title_part else term or title_part
        return title_part

    # För alvin-work och resurstyper antas att title är en lista och det första elementet används
    title_part = joiner.join(
        filter(None, (title[0].get(key) for key in keys))
    )
    return title_part

@register.filter
def alvin_record_title(metadata):
    keys = ["main_title", "subtitle"]
    return " : ".join(filter(None, (metadata.get(key) for key in keys)))

@register.filter
def alvin_person_name(metadata):
    keys = ["given_name", "family_name", "numeration"]
    name = " ".join(filter(None, (metadata.get(key) for key in keys)))
    if metadata.get("terms_of_address"):
        return f"{name}, {metadata['terms_of_address']}"
    return name

@register.filter
def alvin_organisation_name(metadata):
    keys = ["corporate_name", "subordinate_name", "terms_of_address"]

    lst = []

    for key in keys:
        item = (metadata or {}).get(key) or {}
        lst.append(item)
    
    return ". ".join(filter(None, (lst)))

@register.filter
def agent_name(metadata):
    lang = _lang(metadata)
    name = metadata[lang]
    return alvin_person_name(name) if name.get("family_name") else alvin_organisation_name(name)

@register.filter
def alvin_work_name(metadata):
    if isinstance(metadata, list):
        metadata = metadata[0]
    keys = ["main_title", "subtitle"]
    return " : ".join(filter(None, (metadata.get(key) for key in keys)))

@register.filter
def alvin_place_name(metadata):
    lang = select_current_language() if metadata.get(select_current_language()) else next(iter(metadata))
    return metadata.get(lang, {}).get("geographic", "")

@register.filter
def role_list(metadata):
    return ", ".join(filter(None, metadata))

@register.filter
def origin_countries(metadata):
    keys = ["country", "historical_country"]
    
    oc = []

    for key in keys:
        oc += [item for item in metadata.get(key)["items"]] or None

    oc_str = ', '.join(filter(None, (oc)))

    return f", {oc_str}" if oc_str is not None else None 

@register.filter
def date_join(metadata):
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
    return " ".join(filter(None, [joined_date, metadata.get("date_note")])) if joined_date.endswith(".") else " ".join(filter(None, [joined_date, metadata.get("date_note")])) 

@register.filter
def dimensions_label_join(metadata):
    keys = ["label", "scope"]
    return ", ".join(filter(None, (metadata.get(key) for key in keys))).capitalize()

@register.filter
def dimensions_join(metadata):
    keys = ["height", "width", "depth", "diameter"]

    parts = []
    labels = []

    for key in keys:
        item = (metadata or {}).get(key) or {}
        text = item.get("text")
        label = item.get("label")

        if text not in (None, ""):
            parts.append(str(text))

        if label not in (None, ""):
            labels.append(str(label))

    texts_str = " x ".join(filter(None,parts))
    unit_str = metadata.get("unit") or None
    dimensions_str = ' '.join(filter(None, (texts_str, unit_str)))
    labels_str = f"({', '.join(filter(None, (labels)))})"
    return " ".join(filter(None, (dimensions_str, labels_str))).lower()

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
    return ", ".join(filter(None, (metadata.get(key) for key in keys)))

@register.filter
def part_join(metadata):
    keys = ["number", "extent"]
    return ", ".join(filter(None, (metadata.get(key) for key in keys)))