// additional leaflet base layers
GeoBlacklight.Basemaps.esri =  L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.esri_world_imagery = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
  attribution: '&copy; Source: Esri, Maxar, Earthstar Geographics, and the GIS User Community',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
})
