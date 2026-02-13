import OpenSeadragon from "openseadragon";

document.addEventListener("DOMContentLoaded", () => {
  const el = document.querySelector("#tify-viewer");
  if (!el) return;

  // Deny internal server address that OSD might use, and replace with public address
  if (typeof OpenSeadragon !== "undefined" && OpenSeadragon.IIIFTileSource) {
    const originalConfigure = OpenSeadragon.IIIFTileSource.prototype.configure;
    OpenSeadragon.IIIFTileSource.prototype.configure = function (data, url) {
      const publicBaseUrl = url.replace(/\/info\.json$/, "");
      if (data) {
        data["@id"] = publicBaseUrl;
        data["id"] = publicBaseUrl;
      }
      return originalConfigure.call(this, data, url);
    };
  }

  const manifestUrl = el.dataset.manifestUrl;

  // 2. Hämta manifestet
  fetch(manifestUrl)
    .then((r) => r.json())
    .then((manifest) => {
      let tileSources = [];

      // Återställd logik från din originalfil för att extrahera bilder
      if (manifest.sequences && manifest.sequences[0].canvases) {
        // IIIF v2
        tileSources = manifest.sequences[0].canvases.map((canvas) => {
          const image = canvas.images[0].resource;
          if (image.service) {
            const service = Array.isArray(image.service) ? image.service[0] : image.service;
            let serviceId = (service["@id"] || service.id).replace(/\/$/, "");
            return serviceId.endsWith("/info.json") ? serviceId : `${serviceId}/info.json`;
          }
          return { type: 'image', url: image["@id"] || image.id };
        }).filter(Boolean);
      } else if (manifest.items) {
        // IIIF v3
        tileSources = manifest.items.map((item) => {
          try {
            const service = item.items[0].items[0].body.service[0];
            let serviceId = (service.id || service["@id"]).replace(/\/$/, "");
            return `${serviceId}/info.json`;
          } catch (e) { return null; }
        }).filter(Boolean);
      }

      // 3. Initiera OpenSeadragon
      const viewer = OpenSeadragon({
        id: "tify-viewer",
        prefixUrl: "https://openseadragon.github.io/openseadragon/images/",
        tileSources: tileSources,
        sequenceMode: true,
        showRotationControl: true,
        autoHideControls: false,
        element: document.getElementById("osd-wrapper") // Krävs för fullskärm
      });

      // 4. Generera vertikala numrerade tumnaglar
      const thumbList = document.getElementById("thumb-list");
      tileSources.forEach((source, index) => {
        const wrapper = document.createElement("div");
        wrapper.className = "relative group cursor-pointer mb-2";
        
        const number = document.createElement("span");
        number.className = "absolute top-1 left-1 bg-black/70 text-white text-[10px] px-1.5 py-0.5 rounded z-10 border border-white/20";
        number.innerText = index + 1;

        const img = document.createElement("img");
        // Thumbnail URL generation
        const thumbUrl = typeof source === 'string' 
          ? source.replace("/info.json", "/full/160,/0/default.jpg") 
          : source.url;
        
        img.src = thumbUrl;
        img.className = `thumb-item w-full rounded border-2 transition-all ${index === 0 ? "border-orange-500" : "border-transparent"}`;
        img.dataset.index = index;

        wrapper.appendChild(number);
        wrapper.appendChild(img);
        wrapper.onclick = () => viewer.goToPage(index);
        thumbList.appendChild(wrapper);
      });
      
      //Toggle button for thumbnail sidebar
      const sidebar = document.getElementById("thumb-sidebar");
      const toggleBtn = document.getElementById("toggle-thumbs");
      if (toggleBtn && sidebar) {
        toggleBtn.onclick = () => {
          sidebar.classList.toggle("translate-x-full");
        };
      }

      //Active thumbnail highlight and scroll into view
      viewer.addHandler("page", (e) => {
        document.querySelectorAll(".thumb-item").forEach((img, i) => {
          const isActive = i === e.page;
          img.classList.toggle("border-orange-500", isActive);
          img.classList.toggle("border-transparent", !isActive);
          if (isActive) {
            img.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
          }
        });
      });
    })
    .catch((err) => console.error("Failed to load manifest:", err));
});