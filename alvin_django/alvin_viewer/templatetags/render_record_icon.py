from django import template
from django.templatetags.static import static

register = template.Library()

@register.inclusion_tag('./alvin_viewer/_partials/_record_icon_name.html')
def render_record_icon(metadata):
    rt = metadata.record_type

    # authority
    if rt in ('alvin-place','alvin-person','alvin-organisation'):
        mapping = {
            'alvin-place': ('/img/authorityTypes/place.svg', metadata.label, metadata.label),
            'alvin-person': ('/img/authorityTypes/person.svg', metadata.label, metadata.label),
            'alvin-organisation': ('/img/authorityTypes/organisation.svg', metadata.label, metadata.label),
        }
        icon_path, alt, label = mapping[rt] 
        return {'icon_path': icon_path, 'icon_alt': alt, 'label': label,}
    
    if rt == 'alvin-work':

        label = metadata.label
        form_code = metadata.form_of_work.code

        icon_paths = {
            "music": "not",
            "cartography": "car",
            "text": "txt"
        }
        return {
            'icon_path': '/img/authorityTypes/work.svg',
            'icon_alt': label,
            'extra_icon_path': f'/img/recordTypes/{icon_paths[form_code]}.svg' if form_code else None,
            'extra_icon_alt': form_code or '',
            'label': f"{label}{', ' + form_code if form_code else ''}",
        }
    
    # record
    tor = metadata.type_of_resource
    pm = metadata.production_method
    resource_code  = tor.code if tor else None
    type_of_resource = tor.item if tor else None
    production_method = pm.code if pm else None
    label_bits = [type_of_resource]
    if production_method == "manuscript":
        label_bits.append("manuscript")
    
    return {
        'icon_path': f'/img/recordTypes/{resource_code}.svg' if resource_code else '/img/recordTypes/unknown.svg',
        'icon_alt': type_of_resource or 'Unknown',
        'label': ", ".join([b for b in label_bits if b]).capitalize()
    }