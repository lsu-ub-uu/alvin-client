from django.urls import path
from . import views

urlpatterns = [
    path('', views.main, name='main'),
    path('alvin_app/', views.alvin_app, name='alvin_app'),
    path('about.html', views.about, name='about'),
    path('members.html', views.members, name='members'),
    path('copyright.html', views.copyright, name='copyright'),
    path('help.html', views.help, name='help'),
    path('alvin-location/<int:id>', views.location, name='location'),
    path('alvin-place/<int:id>', views.place, name='place'),
]