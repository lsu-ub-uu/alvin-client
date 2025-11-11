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
        if getattr(settings, "DEBUG", False):
            if os.environ.get("RUN_MAIN") != "true":
                logger.info("XML init: skip (DEBUG + autoreload parent process)")
                return

        if not cache.add("text_collector_init_lock", "1", timeout=30):
            logger.info("XML init: skip (lock taken)")
            return

        def _init():
            from alvin_viewer.services.text_collector import _process_xml, get_item_dict
            logger.info("XML init: starting background thread...")
            try:
                _process_xml()
                get_item_dict()
                logger.info("XML init: succeeded")
            except Exception:
                logger.exception("XML init: failed")

        threading.Thread(target=_init, daemon=True).start()