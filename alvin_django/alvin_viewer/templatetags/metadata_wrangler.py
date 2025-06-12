from django import template
from django.utils.translation import get_language

register = template.Library()

def select_current_language():
    lang_options = {
        'sv': 'swe',
        'en': 'eng',
        'no': 'nor'
        }
    
    return lang_options[get_language()]

@register.filter
def alvin_title(metadata, record_type):
    
    # authority_names if place, person, or organisation otherwise main_title
    title = (metadata.get("authority_names")
             if record_type in {"alvin-place", "alvin-person", "alvin-organisation"}
             else metadata.get("main_title"))
    
    # Maps record_type with (joiner, keys)
    mapping = {
        "alvin-place": (None, None),  # Handled separately below
        "alvin-person": (" ", ["given_name", "family_name", "numeration"]),
        "alvin-organisation": (". ", ["corporate_name", "subordinate_name"]),
        "alvin-work": (" : ", ["main_title", "subtitle"]),
        "alvin-record": (" : ", ["main_title", "subtitle"]),
    }
    
    if record_type not in mapping:
        raise ValueError("Record type is not valid")
    
    joiner, keys = mapping[record_type]
    
    # Välj geographic som auktoriserat namn för alvin-place
    if record_type == "alvin-place":
        lang = select_current_language() if title.get(select_current_language()) else next(iter(title))
        return title.get(lang, {}).get("geographic", "")
    
    # För alvin-person och alvin-organisation, join baserad på valt språk
    if record_type in {"alvin-person", "alvin-organisation"}:
        lang = select_current_language() if title.get(select_current_language()) else next(iter(title))
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
def alvin_person_name(metadata):
    keys = ["given_name", "family_name", "numeration"]
    name = " ".join(filter(None, (metadata.get(key) for key in keys)))
    if metadata.get("terms_of_address"):
        return f"{name}, {metadata['terms_of_address']}"
    return name

@register.filter
def alvin_organisation_name(metadata):
    keys = ["corporate_name", "subordinate_name", "terms_of_address"]
    return ". ".join(filter(None, (metadata.get(key) for key in keys)))

@register.filter
def alvin_work_name(metadata):
    # Hantering av namn för listning
    if isinstance(metadata, list):
        metadata = metadata[0]
    # Gemensam hantering av namn
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
    return ", ".join(filter(None, (metadata.get(key) for key in keys)))

@register.filter
def date_other_join(metadata):
    keys = ["start_date", "end_date"]
    joined_date = " -- ".join(filter(None, (metadata.get(key) for key in keys)))
    return ". ".join(filter(None, [joined_date, metadata.get("date_note")]))

@register.filter
def dimensions_join(metadata):
    keys = ["height", "width", "depth", "diameter"]
    return "x".join(filter(None, (metadata.get(key) for key in keys)))

@register.filter
def subjects_join(metadata):
    keys = ["topic", "genreForm", "geographicCoverage", "temporal", "occupation"]
    return ", ".join(filter(None, (metadata.get(key) for key in keys)))

@register.filter
def part_join(metadata):
    keys = ["number", "extent"]
    return ", ".join(filter(None, (metadata.get(key) for key in keys)))
