from django.urls import path
from . import views

urlpatterns = [
    path('search', views.alvin_search, name="alvin_search"),
]
