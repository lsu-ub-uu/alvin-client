export function normalizePathname(pathname) {
  const normalizedPath = new URL(pathname, "https://example.invalid").pathname.replace(/\/+$/, "");
  return normalizedPath || "/";
}

export function isAbsoluteUrl(url) {
  return /^(?:[a-z][a-z\d+\-.]*:)?\/\//i.test(url);
}

export function getDeploymentBasePath(currentPath, viewerPath) {
  const normalizedCurrentPath = normalizePathname(currentPath);
  const normalizedViewerPath = normalizePathname(viewerPath);

  if (normalizedViewerPath === "/" || !normalizedCurrentPath.endsWith(normalizedViewerPath)) {
    return "";
  }

  return normalizedCurrentPath.slice(0, -normalizedViewerPath.length);
}

export function normalizeManifestPath(manifestUrl, viewerPath) {
  return new URL(manifestUrl, `https://example.invalid${normalizePathname(viewerPath)}`).pathname;
}

export function buildPrefixedManifestUrl({ manifestUrl, currentPath, viewerPath, origin }) {
  if (isAbsoluteUrl(manifestUrl)) {
    return null;
  }

  const deploymentBasePath = getDeploymentBasePath(currentPath, viewerPath);
  if (!deploymentBasePath) {
    return null;
  }

  return new URL(`${deploymentBasePath}${normalizeManifestPath(manifestUrl, viewerPath)}`, origin).toString();
}

function getResponseError(response) {
  return response.ok ? new Error("Invalid manifest response") : new Error(`HTTP ${response.status}`);
}

async function readManifest(response) {
  if (!response.ok) {
    return null;
  }

  const contentType = response.headers?.get?.("content-type");
  if (contentType && !contentType.includes("json")) {
    return null;
  }

  try {
    return await response.json();
  } catch {
    return null;
  }
}

export async function loadManifestData({
  manifestUrl,
  currentHref,
  currentPath,
  viewerPath,
  fetchImpl = fetch,
}) {
  const primaryUrl = new URL(manifestUrl, currentHref).toString();
  const primaryResponse = await fetchImpl(primaryUrl);
  const primaryManifest = await readManifest(primaryResponse);

  if (primaryManifest) {
    return primaryManifest;
  }

  const fallbackUrl = buildPrefixedManifestUrl({
    manifestUrl,
    currentPath,
    viewerPath,
    origin: new URL(currentHref).origin,
  });

  if (!fallbackUrl || fallbackUrl === primaryUrl) {
    throw getResponseError(primaryResponse);
  }

  const fallbackResponse = await fetchImpl(fallbackUrl);
  const fallbackManifest = await readManifest(fallbackResponse);

  if (fallbackManifest) {
    return fallbackManifest;
  }

  throw getResponseError(fallbackResponse);
}
