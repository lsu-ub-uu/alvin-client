from django.shortcuts import render
from django.utils.translation import gettext as _
from django.utils.translation import get_language, activate, gettext

def start(request):
    return render(request, "alvin_info/start.html")

def kontakt(request):
    return render(request, "alvin_info/kontakt.html")