from django.shortcuts import render
from django.utils.translation import gettext as _
from django.utils.translation import get_language, activate, gettext

# Create your views here.
def start(request):
    trans = translate(language="en")
    return render(request, "start/start.html")

def translate(language):
    cur_language = get_language()
    try:
        activate(language)
    finally:
        activate(cur_language)