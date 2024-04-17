// additional leaflet base layers
GeoBlacklight.Basemaps.darkMatter = L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
  subdomains: 'abcd',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.positron = L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
  subdomains: 'abcd',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.positronLite = L.tileLayer('https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
  subdomains: 'abcd',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.worldAntique = L.tileLayer('https://cartocdn_{s}.global.ssl.fastly.net/base-antique/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
  subdomains: 'abcd',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.worldEco = L.tileLayer('https://cartocdn_{s}.global.ssl.fastly.net/base-eco/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
  subdomains: 'abcd',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.flatBlue = L.tileLayer('https://cartocdn_{s}.global.ssl.fastly.net/base-flatblue/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
  subdomains: 'abcd',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.midnightCommander = L.tileLayer('https://cartocdn_{s}.global.ssl.fastly.net/base-midnight/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, &copy; <a href="http://carto.com/attributions">Carto</a>',
  subdomains: 'abcd',
  maxZoom: 18,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.openstreetmapHot = L.tileLayer('https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, Tiles courtesy of <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>', 
  subdomains: 'abc',
  maxZoom: 19,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});

GeoBlacklight.Basemaps.openstreetmapStandard = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
  maxZoom: 19,
  worldCopyJump: true,
  detectRetina: true,
  noWrap: false
});
