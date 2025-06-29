const data = document.currentScript.dataset;
var map = L.map('map').setView([data.latitude, data.longitude], 13);
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
  maxZoom: 19,
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);
L.marker([data.latitude,data.longitude]).addTo(map);