from django.core.cache import cache

def handle_metadata_change(payload: dict) -> None:
    print("You're IT!")