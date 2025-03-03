from django import template
from django.utils.translation import get_language

register = template.Library()

@register.filter
def alvin_title(metadata):

    record_type = metadata.get("record_type")
    authority_names = metadata.get("authority_names")

    if record_type == "alvin-place":
        keys = None
    elif record_type == "alvin-person":
        joiner = " "
        keys = [
                "given_name",
                "family_name",
                "numeration"
                ]
    elif record_type == "alvin-organisation":
        joiner = ". "
        keys = [
                "corporate_name",
                "subordinate_name"
                ]
    else:
        ValueError("Record type is not valid")

    # Avgör föredraget språk
    lang = get_language() if authority_names.get(get_language()) else next(iter(authority_names))
    lang_data = authority_names.get(lang, {})

    if record_type == "alvin-place":
        return lang_data.get("geographic", "")

    title_part = joiner.join(filter(None, [lang_data.get(key) for key in keys]))
    term = lang_data.get("term_of_address")
    
    if term:
        return f"{title_part}, {term}" if title_part else term
    return title_part

@register.filter
def alvin_person_name(metadata):
    return " ".join(filter(None, [
                            metadata.get("given_name"), 
                            metadata.get("family_name"), 
                            metadata.get("numeration")
                            ]))

@register.filter
def alvin_organisation_name(metadata):
    return ". ".join(filter(None, [
                            metadata.get("corporate_name"),
                             metadata.get("subordinate_name"),
                             metadata.get("term_of_address")
                            ]))