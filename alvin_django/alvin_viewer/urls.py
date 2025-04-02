from django.urls import path
from . import views

urlpatterns = [
    path('<str:record_type>/<int:record_id>/', views.alvin_viewer, name="alvin_viewer"),
    path('iiif/manifest/<int:record_id>/', views.iiif_manifest, name='iiif_manifest'),
]