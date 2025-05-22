from django.urls import path
from . import views

urlpatterns = [
  path("", views.start, name="start"),
  path("about/", views.about, name="about"),
  path("copyright/", views.copyright, name="copyright"),
  path("kontakt/", views.kontakt, name="kontakt"),
]