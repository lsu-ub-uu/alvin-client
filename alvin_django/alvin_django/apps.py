import os
import threading
from django.apps import AppConfig
from django.core.cache import cache
from django.conf import settings
import logging


logger = logging.getLogger(__name__)


class AlvinAppConfig(AppConfig):
    name = "alvin_django"

    def ready(self):
        if settings.DEBUG and os.environ.get('RUN_MAIN', None) != 'true':
            return

        def _init():
            from services.text_collector import get_item_dict
            from alvin_search.views import cached_locations

            # Ladda collection items
            logger.info("Collecting collection items...")
            try:
                get_item_dict()
                logger.info("Collecting items: succeeded")
            except Exception:
                logger.exception("Collecting items: failed")

            logger.info("Collecting locations...")
            try:
                cached_locations()
                logger.info("Collecting locations: succeeded")
            except Exception:
                logger.exception("Collecting locations: failed")

        threading.Thread(target=_init, daemon=True).start()