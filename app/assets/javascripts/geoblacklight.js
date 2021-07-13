// additional leaflet base layers
GeoBlacklight.Basemaps.esri =  L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}', {
  attribution: false,
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.esri_world_imagery = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
  attribution: false,
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
})
