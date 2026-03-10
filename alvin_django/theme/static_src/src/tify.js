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
    
    // Nya gränssnittskomponenter
    setupPageNavigation(viewer, tileSources.length);
    setupCustomFullscreen();
    loadPdfsInline();
    setupPdfToggle();

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
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return await response.json();
  } catch (error) {
    throw new Error(`Manifest load failed: ${error.message}`);
  }
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

/* ==============================
IIIF Parsing
============================== */

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
    const service = item.items?.[0]?.items?.[0]?.body?.service?.[0];
    const id = service?.id || service?.["@id"];
    return normalizeServiceId(id);
  } catch {
    return null;
  }
}

function extractV2Service(canvas) {
  try {
    const id = canvas.images?.[0]?.resource?.service?.["@id"];
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
    prefixUrl: "/static/openseadragon/images/", 
    tileSources,
    sequenceMode: true,
    showRotationControl: true,
    autoHideControls: false,
    showFullPageControl: false,
    crossOriginPolicy: "Anonymous"
  });
}

/* ==============================
Thumbnails
============================== */

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
    img.src = createThumbnailUrl(source);
    img.dataset.index = index;
    img.className = "thumb-item w-full rounded border-2 transition-all border-transparent";

    if (index === 0) {
      img.classList.remove("border-transparent");
      img.classList.add("border-orange-500");
    }

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
    const newIndex = event.page;
    thumbnails[currentIndex].classList.replace("border-orange-500", "border-transparent");
    
    const activeImg = thumbnails[newIndex];
    activeImg.classList.replace("border-transparent", "border-orange-500");
    
    const isSidebarOpen = sidebar && !sidebar.classList.contains("translate-x-full");
    if (isSidebarOpen) {
      scrollSidebarToActive(sidebar, activeImg);
    }
    currentIndex = newIndex;
  });
}

function setupSidebarToggle() {
  const sidebar = document.getElementById("thumb-sidebar");
  const toggleBtn = document.getElementById("toggle-thumbs");
  if (!sidebar || !toggleBtn) return;

  toggleBtn.addEventListener("click", () => {
    sidebar.classList.toggle("translate-x-full");
    const isOpen = !sidebar.classList.contains("translate-x-full");
    if (isOpen) {
      const activeThumb = sidebar.querySelector(".thumb-item.border-orange-500");
      if (activeThumb) {
        scrollSidebarToActive(sidebar, activeThumb);
      }
    }
  });
}

function createThumbnailUrl(infoJsonUrl, width = 160) {
  return infoJsonUrl.replace(/\/info\.json$/, `/full/${width},/0/default.jpg`);
}

function scrollSidebarToActive(sidebar, activeElement) {
  if (!sidebar || !activeElement) return;
  const sidebarRect = sidebar.getBoundingClientRect();
  const elementRect = activeElement.getBoundingClientRect();
  const offsetTop = elementRect.top - sidebarRect.top;
  const offsetBottom = elementRect.bottom - sidebarRect.bottom;
  
  if (offsetTop < 0) {
    sidebar.scrollTo({ top: sidebar.scrollTop + offsetTop, behavior: "smooth" });
  } else if (offsetBottom > 0) {
    sidebar.scrollTo({ top: sidebar.scrollTop + offsetBottom, behavior: "smooth" });
  }
}

/* ==============================
UI & Fullskärm
============================== */

function setupPageNavigation(viewer, totalPages) {
  const pageInput = document.getElementById("page-input");
  const totalDisplay = document.getElementById("total-pages");
  
  if (!pageInput || !totalDisplay) return;

  totalDisplay.textContent = totalPages;
  pageInput.max = totalPages;
  pageInput.value = 1;

  pageInput.addEventListener("change", (event) => {
    let desiredPage = parseInt(event.target.value, 10);
    if (isNaN(desiredPage) || desiredPage < 1) desiredPage = 1;
    else if (desiredPage > totalPages) desiredPage = totalPages;
    viewer.goToPage(desiredPage - 1);
  });

  viewer.addHandler("page", (event) => {
    pageInput.value = event.page + 1;
  });
}

function setupCustomFullscreen() {
  const fullscreenBtn = document.getElementById("custom-fullscreen-btn");
  const container = document.getElementById("viewer-fullscreen-container");
  
  if (!fullscreenBtn || !container) return;

  fullscreenBtn.addEventListener("click", () => {
    if (!document.fullscreenElement) {
      container.requestFullscreen().catch(err => {
        console.error(`Gick inte att starta fullskärm: ${err.message}`);
      });
    } else {
      document.exitFullscreen();
    }
  });
}

/* ==============================
PDF Hantering & Toggle
============================== */

function setupPdfToggle() {
  const toggleBtn = document.getElementById("toggle-pdf-btn");
  const pdfContainer = document.getElementById("pdf-container");
  const toggleText = document.getElementById("toggle-pdf-text");

  if (!toggleBtn || !pdfContainer) return;

  toggleBtn.addEventListener("click", () => {
    pdfContainer.classList.toggle("hidden");
    
    if (pdfContainer.classList.contains("hidden")) {
      toggleText.textContent = "Visa PDF";
    } else {
      toggleText.textContent = "Dölj PDF";
    }
  });
}

async function loadPdfsInline() {
  const container = document.getElementById("pdf-container");
  if (!container) return;

  const urlsString = container.dataset.pdfUrls;
  if (!urlsString) return;

  const pdfUrls = urlsString.split(',').filter(url => url.trim() !== '');
  if (pdfUrls.length === 0) return;

  const selector = document.getElementById("pdf-selector");
  const iframeWrapper = document.getElementById("pdf-iframe-wrapper");
  
  if (!selector || !iframeWrapper) return;

  selector.innerHTML = '';
  pdfUrls.forEach((url, index) => {
    const option = document.createElement("option");
    option.value = url;
    const filename = url.split('/').pop() || `dokument_${index + 1}.pdf`;
    option.textContent = `Dokument ${index + 1}: ${decodeURIComponent(filename)}`;
    selector.appendChild(option);
  });

  async function renderPdf(url) {
    iframeWrapper.innerHTML = '<div class="absolute inset-0 flex items-center justify-center text-sm font-semibold text-gray-800">Laddar PDF i bakgrunden...</div>';

    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error(`Kunde inte hämta PDF: HTTP ${response.status}`);
      
      const blob = await response.blob();
      const pdfBlob = new Blob([blob], { type: 'application/pdf' });
      const blobUrl = URL.createObjectURL(pdfBlob);

      const iframe = document.createElement("iframe");
      iframe.src = blobUrl;
      iframe.className = "absolute inset-0 w-full h-full border-0 block";
      iframe.title = "PDF-dokument";
      
      iframeWrapper.innerHTML = ''; 
      iframeWrapper.appendChild(iframe);
      
    } catch (error) {
      console.error("Fel vid inladdning av PDF:", error);
      iframeWrapper.innerHTML = `
        <div class="absolute inset-0 p-4 bg-gray-100 flex flex-col justify-center items-center text-center">
          <p class="text-red-600 mb-2">Kunde inte ladda PDF:en direkt i webbläsaren.</p>
          <a href="${url}" class="text-orange-500 underline font-semibold px-4 py-2 border border-orange-500 rounded hover:bg-orange-50" target="_blank">
            Ladda ned filen istället
          </a>
        </div>`;
    }
  }

  selector.addEventListener("change", (event) => {
    renderPdf(event.target.value);
  });

  // Ladda in den första PDF:en i bakgrunden
  renderPdf(pdfUrls[0]);
}