import types
from unittest.mock import Mock

import pytest

from django.core.cache import cache


@pytest.fixture
def sample_xml_bytes():
    return b"""
    <records>
      <record id="1"><title>First</title><text>Alpha</text></record>
      <record id="2"><title>Second</title><text>Beta</text></record>
    </records>
    """


def test_collect_texts_stores_bytes_in_cache(monkeypatch, sample_xml_bytes):
    # Arrange: patch requests.get to return an object with .content
    mock_resp = types.SimpleNamespace()
    mock_resp.content = sample_xml_bytes
    mock_resp.raise_for_status = lambda: None

    monkeypatch.setattr("alvin_viewer.services.text_collector.requests.get", lambda *a, **k: mock_resp)

    # Ensure cache is empty
    cache.delete("collection_item_cache")

    # Act
    from alvin_viewer.services import text_collector as tc

    tc.collect_texts()

    # Assert
    assert cache.get("collection_item_cache") == sample_xml_bytes


def test_get_tree_and_xpath_returns_values(monkeypatch, sample_xml_bytes):
    # Put XML into cache and ensure tree parses
    cache.set("collection_item_cache", sample_xml_bytes)

    from alvin_viewer.services import text_collector as tc

    # Ensure ITEM_TREE is None so reload happens
    tc.ITEM_TREE = None

    tree = tc.get_xml_tree()
    assert tree is not None

    # Use xpath_value to extract titles
    titles = tc.xpath_value("//record/title/text()")
    assert "First" in titles
    assert "Second" in titles


def test_xpath_returns_empty_when_no_tree(monkeypatch):
    # Ensure cache is empty
    cache.delete("collection_item_cache")

    from alvin_viewer.services import text_collector as tc

    tc.ITEM_TREE = None
    values = tc.xpath_value("//record/title/text()")
    assert values == []
