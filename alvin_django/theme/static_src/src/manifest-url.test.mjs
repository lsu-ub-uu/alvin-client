import test from "node:test";
import assert from "node:assert/strict";

import { buildPrefixedManifestUrl, loadManifestData, normalizeManifestPath } from "./manifest-url.mjs";

test("buildPrefixedManifestUrl prepends the deployment base path", () => {
  const manifestUrl = buildPrefixedManifestUrl({
    manifestUrl: "/en/iiif/manifest/1",
    currentPath: "/alvin/en/alvin-record/1",
    viewerPath: "/en/alvin-record/1",
    origin: "https://preview.alvin.cora.epc.ub.uu.se",
  });

  assert.equal(manifestUrl, "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/iiif/manifest/1");
});

test("normalizeManifestPath resolves relative manifest URLs against the viewer route", () => {
  const manifestPath = normalizeManifestPath("iiif/manifest/1", "/en/alvin-record/1");

  assert.equal(manifestPath, "/en/alvin-record/1/iiif/manifest/1");
});

test("loadManifestData retries with a prefixed manifest URL after a 404", async () => {
  const calls = [];
  const responses = [
    { ok: false, status: 404 },
    {
      ok: true,
      status: 200,
      headers: { get: () => "application/json" },
      json: async () => ({ id: "manifest" }),
    },
  ];

  const manifest = await loadManifestData({
    manifestUrl: "/en/iiif/manifest/1",
    currentHref: "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/alvin-record/1?data=%2Falvin%2Fen%2Fsearch",
    currentPath: "/alvin/en/alvin-record/1",
    viewerPath: "/en/alvin-record/1",
    fetchImpl: async (url) => {
      calls.push(url);
      return responses.shift();
    },
  });

  assert.deepEqual(manifest, { id: "manifest" });
  assert.deepEqual(calls, [
    "https://preview.alvin.cora.epc.ub.uu.se/en/iiif/manifest/1",
    "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/iiif/manifest/1",
  ]);
});

test("loadManifestData retries when the primary response is not JSON", async () => {
  const calls = [];
  const responses = [
    {
      ok: true,
      status: 200,
      headers: { get: () => "text/html" },
      json: async () => {
        throw new Error("Unexpected token <");
      },
    },
    {
      ok: true,
      status: 200,
      headers: { get: () => "application/json" },
      json: async () => ({ id: "manifest" }),
    },
  ];

  const manifest = await loadManifestData({
    manifestUrl: "/en/iiif/manifest/1",
    currentHref: "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/alvin-record/1",
    currentPath: "/alvin/en/alvin-record/1",
    viewerPath: "/en/alvin-record/1",
    fetchImpl: async (url) => {
      calls.push(url);
      return responses.shift();
    },
  });

  assert.deepEqual(manifest, { id: "manifest" });
  assert.equal(calls[1], "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/iiif/manifest/1");
});

test("loadManifestData handles relative manifest URLs without requiring a fallback", async () => {
  const calls = [];
  const responses = [{
    ok: true,
    status: 200,
    headers: { get: () => "application/json" },
    json: async () => ({ id: "manifest" }),
  }];

  const manifest = await loadManifestData({
    manifestUrl: "iiif/manifest/1",
    currentHref: "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/alvin-record/1",
    currentPath: "/alvin/en/alvin-record/1",
    viewerPath: "/en/alvin-record/1",
    fetchImpl: async (url) => {
      calls.push(url);
      return responses.shift();
    },
  });

  assert.deepEqual(manifest, { id: "manifest" });
  assert.deepEqual(calls, [
    "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/alvin-record/iiif/manifest/1",
  ]);
});
