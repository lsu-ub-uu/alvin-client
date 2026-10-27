document.addEventListener("DOMContentLoaded", function() {
    var mapElement = document.getElementById('alvin-map');
    if (mapElement) {
        var lat = parseFloat(mapElement.dataset.latitude);
        var lng = parseFloat(mapElement.dataset.longitude);
        var assetPath = mapElement.dataset.leafletAssets || '/static/js/leaflet/images/';
        
        if (!assetPath.endsWith('/')) {
            assetPath += '/';
        }

        if (!isNaN(lat) && !isNaN(lng)) {

            delete L.Icon.Default.prototype._getIconUrl;

            L.Icon.Default.mergeOptions({
                iconRetinaUrl: assetPath + 'marker-icon-2x.png',
                iconUrl: assetPath + 'marker-icon.png',
                shadowUrl: assetPath + 'marker-shadow.png',
                iconSize: [25, 41],
                iconAnchor: [12, 41],
                popupAnchor: [1, -34],
                shadowSize: [41, 41]
            });

            var map = L.map('alvin-map').setView([lat, lng], 13);

            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                subdomains: ['a', 'b', 'c'],
                maxZoom: 19,
                referrerPolicy: 'no-referrer-when-downgrade',
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener noreferrer">OpenStreetMap</a> bidragsgivare'
            }).addTo(map);
            
            L.marker([lat, lng]).addTo(map);
        }
    }
});