from django import template

register = template.Library()

@register.filter
def alvin_person_title(metadata):
    
    title_part = " ".join(filter(None, [metadata["authority_names"]["swe"].get("given_name"), metadata["authority_names"]["swe"].get("family_name")]))

    if metadata["authority_names"]["swe"].get("term_of_address"):
        title = f"{title_part}, {metadata['authority_names']['swe'].get('term_of_address')}" if title_part else metadata["authority_names"]["swe"].get("term_of_address")
    else:
        title = title_part
    
    return title

@register.filter
def alvin_person_name(metadata):

    name = " ".join(filter(None, [metadata["authority_names"]["swe"].get("given_name"), metadata["authority_names"]["swe"].get("family_name")]))

    return name

@register.filter
def alvin_person_birth_date(metadata):

    birth_date = "-".join(filter(None, [metadata["birth_year"], metadata["birth_month"], metadata["birth_day"]]))

    return birth_date

@register.filter
def alvin_person_death_date(metadata):

    death_date = "-".join(filter(None, [metadata["birth_year"], metadata["birth_month"], metadata["birth_day"]]))

    return death_date