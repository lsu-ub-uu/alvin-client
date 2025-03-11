from django.urls import path
from . import views

urlpatterns = [
    path('<str:record_type>/', views.alvin_list_viewer, name="alvin_list_viewer"),
]