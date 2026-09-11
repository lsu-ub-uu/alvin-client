import test from "node:test";
import assert from "node:assert/strict";

import { buildPrefixedManifestUrl, loadManifestData } from "./manifest-url.mjs";

test("buildPrefixedManifestUrl prepends the deployment base path", () => {
  const manifestUrl = buildPrefixedManifestUrl({
    manifestUrl: "/en/iiif/manifest/1",
    currentPath: "/alvin/en/alvin-record/1",
    viewerPath: "/en/alvin-record/1",
    origin: "https://preview.alvin.cora.epc.ub.uu.se",
  });

  assert.equal(manifestUrl, "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/iiif/manifest/1");
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
