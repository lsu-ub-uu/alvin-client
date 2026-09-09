from django.urls import path
from . import views

urlpatterns = [
    path('schema/alvin-record.xsd', views.alvinrecordschema, name='alvinrecordschema'),
    path('vocabulary/<str:id>.rdf', views.metadatardf, name='metadatardf'),
    path('data/<str:record_type>/<str:record_id>', views.record_viewer, name='record_viewer'),
    path('onthology', views.alvinvocabulary, name='alvinvocabulary'),
    path('onthology/alvin.rdf', views.alvinrdf, name='alvinrdf'),
    path('onthology/<str:id>.rdf', views.onthologyrdf, name='onthologyrdf'),
    path('linkedart/v1/<str:tier>', views.linked_art_search_json, name="linked_art_search_json"),
    path('linkedart/activitystream/<str:searchType>', views.linked_art_activity_stream, name="linked_art_activity_stream"),
    path('linkedart/discovery/<str:searchType>', views.linked_art_discovery_stream, name="linked_art_discovery_stream"),

]