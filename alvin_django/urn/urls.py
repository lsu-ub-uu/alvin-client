from django.urls import path
from . import views

urlpatterns = [
    #path('urn2/', views.urncurrent, name='urncurrent'),
    path('urn/', views.urn, name='urn'),
    path('oai/', views.oai, name='oai'),
    path('oai2/', views.xml_feed, name='xml_feed'),
]