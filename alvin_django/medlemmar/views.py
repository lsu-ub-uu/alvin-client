from django.shortcuts import render

# Create your views here.
def medlemmar(request):
    return render(request, "medlemmar/medlemmar.html")