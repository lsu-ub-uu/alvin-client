from django import template

register = template.Library()

@register.inclusion_tag('./alvin_viewer/_partials/_record_icon_name.html')
def render_record_icon(metadata):
    rt = (metadata or {}).get("record_type")

    # authority
    if rt in ('alvin-place','alvin-person','alvin-organisation'):
        mapping = {
            'alvin-place': ('/img/authorityTypes/place.svg', 'Plats', 'Plats'),
            'alvin-person': ('/img/authorityTypes/person.svg', 'Person', 'Person'),
            'alvin-organisation': ('/img/authorityTypes/organisation.svg', 'Organisation', 'Organisation'),
        }
        icon_path, alt, label = mapping[rt] 
        return {'icon_path': icon_path, 'icon_alt': alt, 'label': label,}
    
    if rt == 'alvin-work':
        form = (metadata or {}).get("form_of_work")
        return {
            'icon_path': '/img/recordTypes/work.svg',
            'icon_alt': 'Verk',
            'extra_icon_path': f'/img/recordTypes/{form}.svg' if form else None,
            'extra_icon_alt': form or '',
            'label': f"Verk{', ' + form if form else ''}",
        }
    
    # record
    tor = (metadata or {}).get("type_of_resource", {})
    pm = (metadata or {}).get("production_method", {})
    resource_code  = tor.get("code")
    type_of_resource = tor.get("item")
    production_method = pm.get("code")
    label_bits = [type_of_resource]
    if production_method == "manuscript":
        label_bits.append("manuscript")
    
    return {
        'icon_path': f'/img/recordTypes/{resource_code}.svg' if resource_code else '/img/recordTypes/unknown.svg',
        'icon_alt': type_of_resource or 'Okänd',
        'label': ", ".join([b for b in label_bits if b]).capitalize()
    }