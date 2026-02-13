from django.urls import path
from .views.viewer import alvin_viewer
from .views.iiif import iiif_manifest
from .views.download import download

urlpatterns = [
    path('<str:record_type>/<int:record_id>', alvin_viewer, name="alvin_viewer"),
    path('iiif/manifest/<int:record_id>', iiif_manifest, name='iiif_manifest'),
    path('download/<str:url_type>/<int:record_id>', download, name='download' )
]