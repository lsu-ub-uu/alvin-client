from django.template import Library
from django import template
from django.urls import translate_url
from django.utils.translation import get_language
import re

register = Library()

@register.simple_tag(takes_context=True)
def change_lang(context, lang_code):
    path = context['request'].get_full_path()
    return translate_url(path, lang_code)

@register.filter
def get_path_after_lang(path):
    lang = get_language()
    # Matches /en/ or /en-us/ and returns the rest
    match = re.match(rf'^/{lang}/(.*)', path)
    return match.group(1) if match else path

@register.filter
def prefix_before_i18n(path):
    # Matchar landskoder som /en/, /sv/, /de/ etc.
    match = re.search(r'/(?:[a-z]{2}(?:-[a-z]{2})?)/', path)
    if match:
        return path[:match.start() + 1] # Returnerar allt till och med första "/"
    return path

@register.filter
def strip_lang(path, lang_code):
    # Skapar ett mönster som letar efter /sv/ eller /en/ i början av strängen
    pattern = f'^/{lang_code}/'
    return re.sub(pattern, '/', path)

@register.filter
def split_url_i18n(path):
    # Standard Django i18n patterns look like /en/path/ or /fr-ca/path/
    match = re.match(r'^/([a-z]{2}(?:-[a-z]{2,4})?)/(.*)', path)
    if match:
        return match.group(1), match.group(2)
    return None, path
