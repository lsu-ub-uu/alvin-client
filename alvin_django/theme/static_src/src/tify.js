import OpenSeadragon from "openseadragon";

/* ==============================
Entry
============================== */

document.addEventListener("DOMContentLoaded", init);

async function init() {
  patchIIIFTileSourceBaseUrl();

  const container = document.getElementById("tify-viewer");
  if (!container) return;

  const manifestUrl = container.dataset.manifestUrl;
  if (!manifestUrl) {
    console.error("Missing data-manifest-url attribute.");
    return;
  }

  try {
    const manifest = await loadManifest(manifestUrl);
    const tileSources = extractTileSources(manifest);

    if (!tileSources.length) {
      console.warn("No tileSources found in manifest.");
      return;
    }

    const viewer = createViewer(tileSources);
    const thumbnails = createThumbnails(tileSources, viewer);

    setupActiveThumbnailSync(viewer, thumbnails);
    setupSidebarToggle();

  } catch (error) {
    console.error("Viewer initialization failed:", error);
  }
}

/* ==============================
Data Loading
============================== */

async function loadManifest(url) {
  try {
    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    throw new Error(`Manifest load failed: ${error.message}`);
  }
}

function patchIIIFTileSourceBaseUrl() {
  if (!OpenSeadragon?.IIIFTileSource) return;

  const proto = OpenSeadragon.IIIFTileSource.prototype;

  // Undvik att patcha flera gånger
  if (proto.__isPatched) return;

  const originalConfigure = proto.configure;

  proto.configure = function (data, url) {
    if (data && url) {
      const publicBaseUrl = url.replace(/\/info\.json$/, "");
      data["@id"] = publicBaseUrl;
      data["id"] = publicBaseUrl;
    }

    return originalConfigure.call(this, data, url);
  };

  proto.__isPatched = true;
}

/* ==============================
IIIF Parsing
============================== */

function extractTileSources(manifest) {
  // IIIF v3
  if (Array.isArray(manifest.items)) {
    return manifest.items
      .map(extractV3Service)
      .filter(Boolean);
  }

  // IIIF v2
  if (manifest.sequences?.[0]?.canvases) {
    return manifest.sequences[0].canvases
      .map(extractV2Service)
      .filter(Boolean);
  }

  return [];
}

function extractV3Service(item) {
  try {
    const service =
      item.items?.[0]?.items?.[0]?.body?.service?.[0];

    const id = service?.id || service?.["@id"];
    return normalizeServiceId(id);
  } catch {
    return null;
  }
}

function extractV2Service(canvas) {
  try {
    const id =
      canvas.images?.[0]?.resource?.service?.["@id"];

    return normalizeServiceId(id);
  } catch {
    return null;
  }
}

function normalizeServiceId(id) {
  if (!id) return null;
  const clean = id.replace(/\/$/, "");
  return `${clean}/info.json`;
}

/* ==============================
Viewer Setup
============================== */

function createViewer(tileSources) {
  return OpenSeadragon({
    id: "tify-viewer",
    element: document.getElementById("osd-wrapper"),
    prefixUrl: "/static/openseadragon/images/", // host locally
    tileSources,
    sequenceMode: true,
    showRotationControl: true,
    autoHideControls: false
  });
}

/* ==============================
Thumbnails
============================== */

function createThumbnails(tileSources, viewer) {
  const thumbList = document.getElementById("thumb-list");
  if (!thumbList) return [];

  const thumbnails = [];

  tileSources.forEach((source, index) => {
    const wrapper = document.createElement("div");
    wrapper.className =
      "relative group cursor-pointer mb-2";

    const number = document.createElement("span");
    number.className =
      "absolute top-1 left-1 bg-black/70 text-white text-[10px] px-1.5 py-0.5 rounded z-10 border border-white/20";
    number.textContent = index + 1;

    const img = document.createElement("img");
    img.loading = "lazy";
    img.src = createThumbnailUrl(source);
    img.dataset.index = index;

    img.className =
      "thumb-item w-full rounded border-2 transition-all border-transparent";

    if (index === 0) {
      img.classList.add("border-orange-500");
    }

    wrapper.append(number, img);
    wrapper.addEventListener("click", () =>
      viewer.goToPage(index)
    );

    thumbList.appendChild(wrapper);
    thumbnails.push(img);
  });

  return thumbnails;
}

function createThumbnailUrl(infoJsonUrl, width = 160) {
  return infoJsonUrl.replace(
    "/info.json",
    `/full/${width},/0/default.jpg`
  );
}

/* ==============================
UI Sync
============================== */

function setupActiveThumbnailSync(viewer, thumbnails) {
  if (!thumbnails.length) return;

  viewer.addHandler("page", (event) => {
    thumbnails.forEach((img, i) => {
      const isActive = i === event.page;

      img.classList.toggle("border-orange-500", isActive);
      img.classList.toggle("border-transparent", !isActive);

      if (isActive) {
        img.scrollIntoView({
          behavior: "smooth",
          block: "nearest"
        });
      }
    });
  });
}

function setupSidebarToggle() {
  const sidebar = document.getElementById("thumb-sidebar");
  const toggleBtn = document.getElementById("toggle-thumbs");

  if (!sidebar || !toggleBtn) return;

  toggleBtn.addEventListener("click", () => {
    sidebar.classList.toggle("translate-x-full");
  });
}