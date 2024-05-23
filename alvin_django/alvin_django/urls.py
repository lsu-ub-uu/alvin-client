from django.contrib import admin
from django.urls import path, include
from django.conf.urls.i18n import i18n_patterns
from django.utils.translation import gettext_lazy as _


urlpatterns = [
    path('', include('start.urls')),
    path('kontakt/', include('kontakt.urls')),
    path('medlemmar/', include('medlemmar.urls')),
    path('webbplatskarta/', include('webbplatskarta.urls')),
    path('alvin-place/', include('alvin_place.urls')),
    path('alvin-place/', include('alvin_place_list.urls')),
    path('__reload__/', include('django_browser_reload.urls')),
    path("i18n/", include("django.conf.urls.i18n")),
]

urlpatterns += i18n_patterns (
    path('', include('start.urls')),
    path('kontakt/', include('kontakt.urls')),
    path('medlemmar/', include('medlemmar.urls')),
    path('webbplatskarta/', include('webbplatskarta.urls')),
    path('alvin-place/', include('alvin_place.urls')),
    path('alvin-place/', include('alvin_place_list.urls')),
)