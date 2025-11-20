# Running tests

Quick notes to run tests locally.

With pipenv (recommended, project has `Pipfile`):

```powershell
pipenv install --dev
pipenv run pytest -q
```

On this project the Django package lives in the `alvin_django/` subfolder. When running pytest from the repo root you may need to set PYTHONPATH and any environment variables your `settings.py` expects. Example (PowerShell):

```powershell
$env:PYTHONPATH = 'C:\Users\kenan399\Documents\Alvin\Alvin-Django sandbox\alvin_django'; $env:ALLOWED_HOSTS = 'localhost'; pipenv run pytest -q
```

If you use a plain virtualenv and `requirements.txt`:

```powershell
python -m venv .venv; .\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
pytest -q
```

Notes:
- `Pipfile` already includes `pytest` in dev-packages. The `requirements.txt` was also augmented with `pytest` and `pytest-django` for users who install from requirements.
- `pytest.ini` is configured to use `alvin_django.settings` as `DJANGO_SETTINGS_MODULE`.
