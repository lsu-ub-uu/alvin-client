from django.urls import path
from . import views

urlpatterns = [
  path("", views.alvin_place_list, name="alvin_place_list")  
]