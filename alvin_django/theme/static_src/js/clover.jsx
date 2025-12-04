import React from "react";
import { createRoot } from "react-dom/client";
import Viewer from "@samvera/clover-iiif/viewer";

const CloverApp = () => {
  const manifestUrl = window.CLOVER_MANIFEST_URL;

  const options = {
    credentials: "omit",
    canvasHeight: "70vh",
    language: {
      enabled: true,
      defaultLanguages: ["sv", "no", "en"],
    },
    informationPanel: {
        open: false,
    },
    showDownload: true,
    showTitle: false,
    openSeadragon: {
        gestureSettingsMouse: {
            scrollToZoom: true;
        }
    },
    
  };

  // const customDisplays = [...]
  // const theme = { colors: {...}, fonts: {...} }

  return (
    <Viewer
      iiifContent={manifestUrl}
      options={options}
      // customDisplays={customDisplays}
      // theme={theme}
    />
  );
};

document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("clover-root");
  if (!container) return;
  if (!window.CLOVER_MANIFEST_URL) return;

  const root = createRoot(container);
  root.render(<CloverApp />);
});