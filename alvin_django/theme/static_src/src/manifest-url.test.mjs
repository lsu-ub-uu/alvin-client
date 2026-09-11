import test from "node:test";
import assert from "node:assert/strict";

import { buildPrefixedManifestUrl, fetchManifestResponse } from "./manifest-url.mjs";

test("buildPrefixedManifestUrl prepends the deployment base path", () => {
  const manifestUrl = buildPrefixedManifestUrl({
    manifestUrl: "/en/iiif/manifest/1",
    currentPath: "/alvin/en/alvin-record/1",
    viewerPath: "/en/alvin-record/1",
    origin: "https://preview.alvin.cora.epc.ub.uu.se",
  });

  assert.equal(manifestUrl, "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/iiif/manifest/1");
});

test("fetchManifestResponse retries with a prefixed manifest URL after a 404", async () => {
  const calls = [];
  const responses = [{ status: 404 }, { status: 200 }];

  const response = await fetchManifestResponse({
    manifestUrl: "/en/iiif/manifest/1",
    currentHref: "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/alvin-record/1?data=%2Falvin%2Fen%2Fsearch",
    currentPath: "/alvin/en/alvin-record/1",
    viewerPath: "/en/alvin-record/1",
    fetchImpl: async (url) => {
      calls.push(url);
      return responses.shift();
    },
  });

  assert.equal(response.status, 200);
  assert.deepEqual(calls, [
    "https://preview.alvin.cora.epc.ub.uu.se/en/iiif/manifest/1",
    "https://preview.alvin.cora.epc.ub.uu.se/alvin/en/iiif/manifest/1",
  ]);
});
