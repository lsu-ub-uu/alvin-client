from django import template

register = template.Library()

@register.inclusion_tag('./alvin_viewer/_partials/_record_icon_name.html')
def render_record_icon(metadata):
    if metadata["record_type"] == 'alvin-place':
        return {
            'icon_path': '/img/authorityTypes/place.svg',
            'icon_alt': 'Plats',
            'label': 'Plats',
        }
    elif metadata["record_type"] == 'alvin-person':
        return {
            'icon_path': '/img/authorityTypes/person.svg',
            'icon_alt': 'Person',
            'label': 'Person'
        }
    elif metadata["record_type"] == 'alvin-organisation':
        return {
            'icon_path': '/img/authorityTypes/organisation.svg',
            'icon_alt': 'Organisation',
            'label': 'Organisation',
        }
    elif metadata["record_type"] == 'alvin-work':
        return {
            'icon_path': '/img/authorityTypes/work.svg',
            'icon_alt': 'Verk',
            'extra_icon_path': f'/img/recordTypes/{metadata["form_of_work"]}.svg',
            'extra_icon_alt': f'{metadata["form_of_work"]}',
            'label': f'Verk, {metadata["form_of_work"]}',
        }
    else: 
        type_of_resource = (metadata or {}).get("type_of_resource", {}).get("item")
        resource_code = (metadata or {}).get("type_of_resource", {}).get("code")
        production_method = (metadata or {}).get("production_method", {}).get("item") if (metadata or {}).get("production_method", {}).get("code") == 'manuscript' else None
        
        return {
            'icon_path': f'/img/recordTypes/{resource_code}.svg',
            'icon_alt': type_of_resource,
            'label': f"{', '.join(filter(None, (type_of_resource, production_method)))}".capitalize()
        }