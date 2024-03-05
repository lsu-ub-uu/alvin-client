from django.urls import path
from . import views

urlpatterns = [
    path("<str:place_id>/", views.alvin_place, name="alvin_place")
]