// B1G Namespace
if (!window.B1G){ B1G={}; }

B1G.baseLayerMap = {
  "OpenStreetMap": 'openstreetmapStandard',
  "World Eco (Carto)": 'worldEco',
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
