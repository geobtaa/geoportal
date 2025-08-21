GeoBlacklight.Viewer.Geojson = GeoBlacklight.Viewer.Map.extend({
  load: function() {
    this.map = L.map(this.element).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());

    if (this.data.available) {
      this.addPreviewLayer();
    } else {
      this.addBoundsOverlay(this.options.bbox);
    }

    // B1G Customizations
    this.addFullscreenControl();
    this.addBasemapSwitcher();
  },
  addPreviewLayer: function() {
    var _this = this;
    var geoJSONLayer;
    var options = this.data.leafletOptions;
    $.getJSON(this.data.url, function(data) {
      geoJSONLayer = L.geoJson(data, {
        onEachFeature: function(feature, layer) {
          // Add popup on click if properties exist
          if (feature.properties && Object.keys(feature.properties).length > 0) {
            var popupContent = _this.createPopupContent(feature.properties);
            layer.bindPopup(popupContent);
            
            // Add hover effect
            layer.on('mouseover', function() {
              layer.setStyle({
                weight: 3,
                color: '#666',
                dashArray: '',
                fillOpacity: 0.7
              });
              if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
                layer.bringToFront();
              }
            });
            
            layer.on('mouseout', function() {
              geoJSONLayer.resetStyle(layer);
            });
          }
        }
      }).addTo(_this.map);
      _this.map.fitBounds(geoJSONLayer.getBounds());
    });
  },
  
  createPopupContent: function(properties) {
    var content = '<div class="geojson-popup"><table class="table table-sm table-striped table-bordered">';
    for (var key in properties) {
      if (properties.hasOwnProperty(key)) {
        var value = properties[key];
        // Format the value - handle arrays, objects, and long strings
        if (Array.isArray(value)) {
          value = value.join(', ');
        } else if (typeof value === 'object' && value !== null) {
          value = JSON.stringify(value);
        } else if (typeof value === 'string' && value.length > 100) {
          value = value.substring(0, 100) + '...';
        }
        
        content += '<tr>';
        content += '<th class="text-nowrap">' + key + '</th>';
        content += '<td>' + value + '</td>';
        content += '</tr>';
      }
    }
    content += '</table></div>';
    return content;
  }
});
