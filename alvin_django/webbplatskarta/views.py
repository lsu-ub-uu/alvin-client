from django.shortcuts import render

# Create your views here.
def webbplatskarta(request):
    return render(request, "webbplatskarta/webbplatskarta.html")