import Tify from "tify";

document.addEventListener("DOMContentLoaded", () => {
  const el = document.querySelector("#tify-viewer");
  if (!el) return;

  const manifestUrl = el.dataset.manifestUrl;

  new Tify({
    container: "#tify-viewer",
    manifestUrl: manifestUrl,
  });
});