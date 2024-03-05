from django.urls import path
from . import views

urlpatterns = [
  path("", views.kontakt, name="kontakt")  
]