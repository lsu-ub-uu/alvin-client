"""Top-level pytest conftest.

This file runs very early during pytest startup. It ensures the nested
`alvin_django` package directory is on sys.path so pytest-django can import
the project, and it provides sane defaults for environment variables that
the project's `settings.py` expects (so tests run without manual shell setup).
"""
import os
import sys

# Insert the inner Django project folder (which contains manage.py and the
# actual package) into sys.path when running pytest from the repository root.
ROOT = os.path.dirname(__file__)
PROJECT_PKG_PATH = os.path.join(ROOT, "alvin_django")
if PROJECT_PKG_PATH not in sys.path:
    # Put it at the front so imports prefer the project package.
    sys.path.insert(0, PROJECT_PKG_PATH)

# Provide minimal environment defaults required by settings.py so importing
# the settings module during test discovery doesn't KeyError.
os.environ.setdefault("ALLOWED_HOSTS", "localhost")
# pytest.ini already sets DJANGO_SETTINGS_MODULE for pytest-django, but set
# a fallback here as well so other tooling/imports behave consistently.
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "alvin_django.settings")
