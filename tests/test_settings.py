def test_settings_loaded():
    """Simple smoke test to ensure Django settings are available to pytest-django."""
    from django.conf import settings

    assert settings.configured
    # Ensure INSTALLED_APPS (or similar) exists on the settings object
    assert hasattr(settings, 'INSTALLED_APPS')
