export function normalizePathname(pathname) {
  const normalizedPath = new URL(pathname, "https://example.invalid").pathname.replace(/\/+$/, "");
  return normalizedPath || "/";
}

export function getDeploymentBasePath(currentPath, viewerPath) {
  const normalizedCurrentPath = normalizePathname(currentPath);
  const normalizedViewerPath = normalizePathname(viewerPath);

  if (normalizedViewerPath === "/" || !normalizedCurrentPath.endsWith(normalizedViewerPath)) {
    return "";
  }

  return normalizedCurrentPath.slice(0, -normalizedViewerPath.length);
}

export function buildPrefixedManifestUrl({ manifestUrl, currentPath, viewerPath, origin }) {
  if (!manifestUrl.startsWith("/")) {
    return null;
  }

  const deploymentBasePath = getDeploymentBasePath(currentPath, viewerPath);
  if (!deploymentBasePath) {
    return null;
  }

  return new URL(`${deploymentBasePath}${manifestUrl}`, origin).toString();
}

export async function fetchManifestResponse({
  manifestUrl,
  currentHref,
  currentPath,
  viewerPath,
  fetchImpl = fetch,
}) {
  const primaryUrl = new URL(manifestUrl, currentHref).toString();
  let response = await fetchImpl(primaryUrl);

  if (response.status !== 404 || !manifestUrl.startsWith("/")) {
    return response;
  }

  const fallbackUrl = buildPrefixedManifestUrl({
    manifestUrl,
    currentPath,
    viewerPath,
    origin: new URL(currentHref).origin,
  });

  if (!fallbackUrl || fallbackUrl === primaryUrl) {
    return response;
  }

  return fetchImpl(fallbackUrl);
}
