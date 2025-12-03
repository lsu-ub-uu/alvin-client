from django.urls import path
from . import views

urlpatterns = [
    path('members/', views.members, name='members'),
    path('search', views.alvin_search, name="alvin_search"),
]
