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

        def _init():
            from alvin_viewer.services.text_collector import get_item_dict
            logger.info("Collecting collection items...")
            try:
                get_item_dict()
                logger.info("Collecting: succeeded")
            except Exception:
                logger.exception("Collecting: failed")

        threading.Thread(target=_init, daemon=True).start()