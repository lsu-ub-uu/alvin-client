from django.contrib import admin
from django.urls import path, include
from django.conf.urls.i18n import i18n_patterns
from django.utils.translation import gettext_lazy as _

urlpatterns = [
    path('i18n/', include("django.conf.urls.i18n")),
]

urlpatterns += i18n_patterns (
    path('', include('alvin_info.urls')),
    path('', include('alvin_viewer.urls')),
    path('', include('alvin_list_viewer.urls')),
    path('search/', include('search.urls')),
)
