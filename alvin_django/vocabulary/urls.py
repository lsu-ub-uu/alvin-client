from django.urls import path
from . import views

urlpatterns = [
    path('userguide/', views.userguide, name='userguide'),
    path('api/rest-api/', views.rest_api, name='rest-api'),
    path('api/oai-pmh/', views.oai_pmh, name='oai-pmh'),
    path('api/iiif/', views.iiif, name='iiif'),
    path('vocabulary/', views.vocabulary, name='vocabulary'),
    path('vocabulary/<str:id>', views.metadata, name='metadata'),
    path('cataloguing/', views.cataloguing, name='cataloguing'),
    path('cataloguing/place/', views.place, name='place'),
    path('cataloguing/person/', views.person, name='person'),
    path('cataloguing/organisation/', views.organisation, name='organisation'),
]
