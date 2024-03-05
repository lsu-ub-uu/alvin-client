from django.shortcuts import render

# Create your views here.
def kontakt(request):
    return render(request, "kontakt/kontakt.html")