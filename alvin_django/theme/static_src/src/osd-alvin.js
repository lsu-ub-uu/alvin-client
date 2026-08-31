import OpenSeadragon from "openseadragon";

/* ==============================
Entry
============================== */

document.addEventListener("DOMContentLoaded", init);

async function init() {
  patchIIIFTileSourceBaseUrl();

  const container = document.getElementById("osd-viewer");
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
    id: "osd-viewer", 
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

const THUMB_PAGE_SIZE = 1;

function createThumbnails(tileSources, viewer) {
  const thumbList = document.getElementById("thumb-list");
  const paginationContainer = document.getElementById("thumb-pagination-top");
  
  if (!thumbList) return { thumbnails: [], renderThumbPage: () => {}, total: 0 };

  const thumbnails = new Array(tileSources.length);
  const totalPages = Math.ceil(tileSources.length / THUMB_PAGE_SIZE);

  function renderThumbPage(pageIndex) {
    thumbList.innerHTML = "";
    const fragment = document.createDocumentFragment();

    const startIndex = pageIndex * THUMB_PAGE_SIZE;
    const endIndex = Math.min(startIndex + THUMB_PAGE_SIZE, tileSources.length);

    for (let i = startIndex; i < endIndex; i++) {
      const source = tileSources[i];
      const wrapper = document.createElement("div");
      wrapper.className = "relative group cursor-pointer mb-2";

      const number = document.createElement("span");
      number.className = "absolute top-1 left-1 bg-black/70 text-white text-[10px] px-1.5 py-0.5 rounded z-10 border border-white/20 pointer-events-none";
      number.textContent = i + 1;

      const img = document.createElement("img");
      img.loading = "lazy";
      img.src = source.replace(/\/info\.json$/, `/full/160,/0/default.jpg`);
      
      const isActive = viewer.currentPage ? viewer.currentPage() === i : (i === 0);
      img.className = `thumb-item w-full rounded border-2 transition-all ${isActive ? 'border-orange-500' : 'border-transparent'}`;
      
      wrapper.append(number, img);
      wrapper.addEventListener("click", () => viewer.goToPage(i));

      fragment.appendChild(wrapper);
      thumbnails[i] = img; 
    }
    
    thumbList.appendChild(fragment);

    // Pagination controls
    if (paginationContainer) {
      paginationContainer.innerHTML = ""; 

      if (totalPages > 1) {
        // Left arrow
        const prevBtn = document.createElement("button");

        prevBtn.className = "p-1.5 rounded-full text-gray-500 hover:bg-black/5 dark:hover:bg-white/10 hover:text-orange-500 transition-all disabled:opacity-30 disabled:cursor-not-allowed";
        prevBtn.innerHTML = `<svg class="w-4 h-4 md:w-5 md:h-5" viewBox="0 0 24 24" stroke-width="2" fill="none" color="currentColor"><path d="M21 12L3 12M3 12L11.5 3.5M3 12L11.5 20.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>`;
        prevBtn.disabled = pageIndex === 0;
        prevBtn.onclick = () => renderThumbPage(pageIndex - 1);

        // Page number
        const pageInfo = document.createElement("span");
        pageInfo.className = "text-xs md:text-sm font-semibold px-2 text-gray-600 dark:text-gray-300 select-none";
        pageInfo.textContent = `${pageIndex + 1} / ${totalPages}`;

        // Right arrow
        const nextBtn = document.createElement("button");
        nextBtn.className = "p-1.5 rounded-full text-gray-500 hover:bg-black/5 dark:hover:bg-white/10 hover:text-orange-500 transition-all disabled:opacity-30 disabled:cursor-not-allowed";
        nextBtn.innerHTML = `<svg class="w-4 h-4 md:w-5 md:h-5" viewBox="0 0 24 24" stroke-width="2" fill="none" xmlns="http://www.w3.org/2000/svg" color="currentColor"><path d="M3 12L21 12M21 12L12.5 3.5M21 12L12.5 20.5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>`;
        nextBtn.disabled = pageIndex === totalPages - 1;
        nextBtn.onclick = () => renderThumbPage(pageIndex + 1);

        paginationContainer.append(prevBtn, pageInfo, nextBtn);
      }
    }
  }

  renderThumbPage(0);
  
  return { thumbnails, renderThumbPage, total: tileSources.length };
}


function setupActiveThumbnailSync(viewer, thumbData) {
  if (!thumbData || thumbData.total === 0) return;
  let currentIndex = 0; 
  const sidebar = document.getElementById("thumb-sidebar");

  viewer.addHandler("page", (event) => {
    if (thumbData.thumbnails[currentIndex]) {
      thumbData.thumbnails[currentIndex].classList.replace("border-orange-500", "border-transparent");
    }
    
    currentIndex = event.page;
    const expectedThumbPage = Math.floor(currentIndex / THUMB_PAGE_SIZE);

    if (!thumbData.thumbnails[currentIndex] || !thumbData.thumbnails[currentIndex].isConnected) {
      thumbData.renderThumbPage(expectedThumbPage);
    }

    const activeImg = thumbData.thumbnails[currentIndex];
    if (activeImg) {
      activeImg.classList.replace("border-transparent", "border-orange-500");
      
      if (sidebar && !sidebar.classList.contains("translate-x-full")) {
        activeImg.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }
    }
  });
}