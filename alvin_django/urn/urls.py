from django.urls import path
from . import views

urlpatterns = [
    #path('alvin/urn2/', views.urncurrent, name='urncurrent'),
    path('alvin/urn/', views.urn, name='urn'),
    path('schema/alvin-record.xsd', views.alvinrecordschema, name='alvinrecordschema'),
    path('vocabulary/rdf/<str:id>', views.metadatardf, name='metadatardf'),
    path('record/<str:record_type>/<str:record_id>', views.record_viewer, name='record_viewer'),
]