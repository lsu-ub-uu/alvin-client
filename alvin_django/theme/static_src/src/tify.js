import OpenSeadragon from "openseadragon";

document.addEventListener("DOMContentLoaded", () => {
  const el = document.querySelector("#tify-viewer");
  if (!el) return;

  if (el.clientHeight === 0) {
    el.style.height = "80vh";
  }

  // Patch för att tvinga OpenSeadragon att använda den publika URL:en istället för interna adresser
  if (typeof OpenSeadragon !== "undefined" && OpenSeadragon.IIIFTileSource) {
    const originalConfigure = OpenSeadragon.IIIFTileSource.prototype.configure;
    OpenSeadragon.IIIFTileSource.prototype.configure = function (data, url) {
      // 'url' är den fungerande adressen till info.json (t.ex. https://publik-doman.se/iiif/.../info.json)
      // Vi extraherar bas-URL:en genom att ta bort /info.json
      const publicBaseUrl = url.replace(/\/info\.json$/, "");

      if (data) {
        // Tvinga @id (IIIF v2) och id (IIIF v3) att vara den publika adressen
        data["@id"] = publicBaseUrl;
        data["id"] = publicBaseUrl;
      }

      return originalConfigure.call(this, data, url);
    };
  }

  const manifestUrl = el.dataset.manifestUrl;

  // Hämta IIIF-manifestet
  fetch(manifestUrl)
    .then((response) => response.json())
    .then((manifest) => {
      console.log("Manifest laddat:", manifest); // Debugging: Se vad vi fick från servern
      let tileSources = [];

      // Logik för att extrahera bild-URL:er från ett IIIF Presentation 2.0/3.0 manifest
      if (manifest.sequences && manifest.sequences[0].canvases) {
        // IIIF v2
        tileSources = manifest.sequences[0].canvases.map((canvas) => {
          const image = canvas.images[0].resource;

          if (image.service) {
            const service = Array.isArray(image.service) ? image.service[0] : image.service;
            let serviceId = service["@id"] || service.id;
            serviceId = serviceId.replace(/\/$/, ""); // Ta bort eventuell avslutande slash för att undvika dubbla //
            return serviceId.endsWith("/info.json") ? serviceId : `${serviceId}/info.json`;
          } else {
            // Fallback: Om ingen IIIF-service finns, använd bilden direkt (statisk bild)
            return { type: 'image', url: image["@id"] || image.id };
          }
        }).filter(Boolean);
      } else if (manifest.items) {
        // IIIF v3
        tileSources = manifest.items.map((item) => {
          try {
            // Gräv fram service-id från body -> service
            const service = item.items[0].items[0].body.service[0];
            let serviceId = service.id || service["@id"];
            serviceId = serviceId.replace(/\/$/, "");

            // Om URL:en redan är intern här (från manifestet), 
            // kan du behöva en .replace("http://alvin-iipimageserver", "https://din-publika-doman.se")
            return serviceId.endsWith("/info.json") ? serviceId : `${serviceId}/info.json`;
          } catch (e) {
            return null;
          }
        }).filter(Boolean);
      }

      console.log("TileSources:", tileSources); // Debugging: Se vilka bildlänkar vi hittade

      // Initiera OpenSeadragon
      const viewer = OpenSeadragon({
        id: "tify-viewer",
        prefixUrl: "https://openseadragon.github.io/openseadragon/images/", // Standardikoner (kan döljas/bytas)
        tileSources: tileSources,
        sequenceMode: true, // Aktiverar bläddring mellan sidor
        showNavigator: true, // Visa liten översiktsruta
        autoHideControls: false, // Dölj inte kontroller automatiskt
        crossOriginPolicy: "Anonymous", // Viktigt för IIIF-bilder från andra domäner
        // Koppla egna knappar här om du vill använda Alpine/HTML-knappar istället:
        // zoomInButton: "my-zoom-in-btn",
        // nextButton: "my-next-btn",
      });

      const thumbContainer = document.querySelector("#thumbnail-strip");

      tileSources.forEach((source, index) => {
        const img = document.createElement("img");

        // Vi genererar en tumnagels-URL baserat på IIIF-standarden
        // Vi tar info.json-URL:en och byter ut slutet mot en tumnagel-path
        const thumbUrl = source.replace("/info.json", "/full/120,/0/default.jpg");

        img.src = thumbUrl;
        img.classList.add("thumb-item");
        if (index === 0) img.classList.add("active"); // Markera första som aktiv

        img.onclick = () => {
          viewer.goToPage(index); // Navigera i OSD
        };

        thumbContainer.appendChild(img);
      });

      // Lyssna på när användaren bläddrar i visaren för att uppdatera aktiv tumnagel
      viewer.addHandler("page", function (data) {
        document.querySelectorAll(".thumb-item").forEach((thumb, idx) => {
          thumb.classList.toggle("active", idx === data.page);

          // Scrolla tumnageln i vy om den hamnar utanför
          if (idx === data.page) {
            thumb.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
          }
        });
      });
    })
    .catch((err) => console.error("Kunde inte ladda manifest:", err));
});