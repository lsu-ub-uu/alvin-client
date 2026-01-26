from django.shortcuts import render
from django.utils.translation import gettext as _

def start(request):
    return render(request, "alvin_info/start.html")

def about(request):
    return render(request, "alvin_info/about.html")

def copyright(request):
    return render(request, "alvin_info/copyright.html")

def kontakt(request):
    return render(request, "alvin_info/contact.html")