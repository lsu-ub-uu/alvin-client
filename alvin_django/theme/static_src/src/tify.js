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

    if (!tileSources.length) return;

    const viewer = createViewer(tileSources);
    const thumbnails = createThumbnails(tileSources, viewer);
    
    setupActiveThumbnailSync(viewer, thumbnails);

    window.dispatchEvent(new CustomEvent('osd-loaded', { detail: { totalPages: tileSources.length } }));

    viewer.addHandler('page', (event) => {
      window.dispatchEvent(new CustomEvent('osd-page-changed', { detail: { page: event.page } }));
    });

    viewer.addHandler('open', () => {
      if (viewer.viewport) viewer.viewport.goHome(true); 
    });

    const osdWrapper = document.getElementById("osd-wrapper");
    if (osdWrapper) {
      const resizeObserver = new ResizeObserver(() => {
        window.dispatchEvent(new Event('resize'));
      });
      resizeObserver.observe(osdWrapper);
    }

  } catch (error) {
    console.error("Viewer initialization failed:", error);
  }
}

/* ==============================
Data Loading and IIIF
============================== */

async function loadManifest(url) {
  const response = await fetch(url);
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  return await response.json();
}

function patchIIIFTileSourceBaseUrl() {
  if (!OpenSeadragon?.IIIFTileSource) return;
  const proto = OpenSeadragon.IIIFTileSource.prototype;
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

function extractTileSources(manifest) {
  if (Array.isArray(manifest.items)) {
    return manifest.items.map(extractV3Service).filter(Boolean);
  }
  if (manifest.sequences?.[0]?.canvases) {
    return manifest.sequences[0].canvases.map(extractV2Service).filter(Boolean);
  }
  return [];
}

function extractV3Service(item) {
  try {
    const id = item.items?.[0]?.items?.[0]?.body?.service?.[0]?.["@id"] || item.items?.[0]?.items?.[0]?.body?.service?.[0]?.id;
    return id ? `${id.replace(/\/$/, "")}/info.json` : null;
  } catch { return null; }
}

function extractV2Service(canvas) {
  try {
    const id = canvas.images?.[0]?.resource?.service?.["@id"];
    return id ? `${id.replace(/\/$/, "")}/info.json` : null;
  } catch { return null; }
}

/* ==============================
Viewer Setup and Thumbnails
============================== */

function createViewer(tileSources) {
  const viewer = OpenSeadragon({
    id: "tify-viewer", 
    prefixUrl: "/static/openseadragon/images/", 
    tileSources,
    sequenceMode: true,
    showNavigationControl: false,
    showSequenceControl: false,
    crossOriginPolicy: "Anonymous"
  });
  
  window.osdViewer = viewer;
  return viewer;
}

function createThumbnails(tileSources, viewer) {
  const thumbList = document.getElementById("thumb-list");
  if (!thumbList) return [];

  const fragment = document.createDocumentFragment();
  const thumbnails = [];

  tileSources.forEach((source, index) => {
    const wrapper = document.createElement("div");
    wrapper.className = "relative group cursor-pointer mb-2";

    const number = document.createElement("span");
    number.className = "absolute top-1 left-1 bg-black/70 text-white text-[10px] px-1.5 py-0.5 rounded z-10 border border-white/20 pointer-events-none";
    number.textContent = index + 1;

    const img = document.createElement("img");
    img.loading = "lazy";
    img.src = source.replace(/\/info\.json$/, `/full/160,/0/default.jpg`);
    img.className = `thumb-item w-full rounded border-2 transition-all ${index === 0 ? 'border-orange-500' : 'border-transparent'}`;

    wrapper.append(number, img);
    wrapper.addEventListener("click", () => viewer.goToPage(index));

    fragment.appendChild(wrapper);
    thumbnails.push(img);
  });

  thumbList.innerHTML = "";
  thumbList.appendChild(fragment);
  return thumbnails;
}

function setupActiveThumbnailSync(viewer, thumbnails) {
  if (!thumbnails.length) return;
  let currentIndex = 0; 
  const sidebar = document.getElementById("thumb-sidebar");

  viewer.addHandler("page", (event) => {
    thumbnails[currentIndex].classList.replace("border-orange-500", "border-transparent");
    const activeImg = thumbnails[event.page];
    activeImg.classList.replace("border-transparent", "border-orange-500");
    
    if (sidebar && !sidebar.classList.contains("translate-x-full")) {
      activeImg.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
    currentIndex = event.page;
  });
}