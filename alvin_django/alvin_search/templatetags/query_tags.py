from django import template

register = template.Library()

@register.simple_tag
def remove_filter(request, key):
    get_copy = request.GET.copy()
    if key in get_copy:
        del get_copy[key]
    return get_copy.urlencode()
