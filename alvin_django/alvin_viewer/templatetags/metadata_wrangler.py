from django import template
from django.utils.translation import get_language

register = template.Library()

@register.filter
def alvin_title(metadata, record_type):

    # authority_names om plats, person, eller organisation, annars main_title
    title = (metadata.get("authority_names")
             if record_type in {"alvin-place", "alvin-person", "alvin-organisation"}
             else metadata.get("main_title"))

    # Mappar record_type med (joiner, keys)
    mapping = {
        "alvin-place": (None, None),  # Hanteras separat nedan
        "alvin-person": (" ", ["given_name", "family_name", "numeration"]),
        "alvin-organisation": (". ", ["corporate_name", "subordinate_name"]),
        "alvin-work": (" : ", ["main_title", "subtitle"]),
    }
    
    if record_type not in mapping:
        raise ValueError("Record type is not valid")
    
    joiner, keys = mapping[record_type]
    
    # För alvin-place, välj geographic som auktoriserat namn
    if record_type == "alvin-place":
        lang = get_language() if title.get(get_language()) else next(iter(title))
        return title.get(lang, {}).get("geographic", "")
    
    # För alvin-person och alvin-organisation, join baserad på valt språk
    if record_type in {"alvin-person", "alvin-organisation"}:
        lang = get_language() if title.get(get_language()) else next(iter(title))
        lang_data = title.get(lang, {})
        title_part = joiner.join(filter(None, (lang_data.get(key) for key in keys)))
        if record_type == "alvin-person":
            term = lang_data.get("term_of_address")
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
    return " ".join(filter(None, (metadata.get(key) for key in keys)))


@register.filter
def alvin_organisation_name(metadata):
    keys = ["corporate_name", "subordinate_name", "term_of_address"]
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
    lang = get_language() if metadata.get(get_language()) else next(iter(metadata))
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