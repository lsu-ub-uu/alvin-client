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
    elif metadata["type_of_resource"] == 'img':
        return {
            'icon_path': f'/img/recordTypes/image.svg',
            'icon_alt': 'Bild',
            'label': 'Bild',
        }
    elif metadata["type_of_resource"] == 'not':
        return {
            'icon_path': f'/img/recordTypes/music.svg',
            'icon_alt': 'Not',
            'label': 'Musik',
        }
    elif metadata["type_of_resource"] == 'txt':
        return {
            'icon_path': f'/img/recordTypes/text.svg',
            'icon_alt': 'Text',
            'label': 'Text',
        }
    elif metadata["type_of_resource"] == 'col':
        return {
            'icon_path': f'/img/recordTypes/archive.svg',
            'icon_alt': 'Arkiv',
            'label': 'Arkiv',
        }
    return {}