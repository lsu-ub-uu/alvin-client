from django.core.cache import cache
from services.text_collector import _reload_items

def handle_metadata_change(payload: dict) -> None:
    _reload_items()