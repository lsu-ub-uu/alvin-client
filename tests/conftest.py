import pytest
import os

# Project-wide fixtures for tests.
from django.core.cache import cache


@pytest.fixture(autouse=True)
def clear_cache_and_tree():
	"""Clear Django cache and reset the module-level ITEM_TREE before each test.

	This ensures tests run with a clean slate and don't rely on previous
	test runs or external network calls.
	"""
	# clear Django cache
	try:
		cache.clear()
	except Exception:
		# If cache backend isn't configured, ignore — tests that need cache will
		# mock it.
		pass

	# ensure environment defaults don't leak between tests
	os.environ.setdefault("ALLOWED_HOSTS", "localhost")

	# Reset module-level ITEM_TREE if present
	try:
		import alvin_viewer.services.text_collector as tc

		tc.ITEM_TREE = None
	except Exception:
		# module may not exist for some tests; ignore
		pass

	yield

