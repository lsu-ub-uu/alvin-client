from django.urls import path
from . import views

urlpatterns = [
    path('', views.start, name='start'),
    path('about/', views.about, name='about'),
    path('institutions/', views.institutions, name='institutions'),
    path('alvin-location/', views.location, name='location'),
    path('copyright/', views.copyright, name='copyright'),
    path('help/', views.help, name='help'),
]
