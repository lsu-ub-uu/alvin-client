from django.urls import path
from . import views

urlpatterns = [
    #path('alvin/urn2/', views.urncurrent, name='urncurrent'),
    path('alvin/urn/', views.urn, name='urn'),
    path('schema/alvin-record.xsd', views.alvinrecordschema, name='alvinrecordschema'),
    path('vocabulary/<str:id>.rdf', views.metadatardf, name='metadatardf'),
    path('data/<str:record_type>/<str:record_id>', views.record_viewer, name='record_viewer'),
    path('onthology', views.alvinvocabulary, name='alvinvocabulary'),
    path('onthology/alvin.rdf', views.alvinrdf, name='alvinrdf'),
    path('onthology/<str:id>.rdf', views.onthologyrdf, name='onthologyrdf'),
]