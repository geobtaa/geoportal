// B1G Namespace
if (!window.B1G){ B1G={}; }

B1G.baseLayerMap = {
  "Default (Esri)": 'esri',
  "OpenStreetMaps": 'openstreetmapStandard',
  "World Imagery (Esri)": 'esri_world_imagery'
}

// B1G Geoportal Behaviors
$(document).ready(function() {
  $(function () {
    $('[data-toggle="popover"]').popover({
      trigger: 'hover'
    })
  })
});
