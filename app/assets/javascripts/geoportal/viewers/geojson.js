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
      geoJSONLayer = L.geoJson(data).addTo(_this.map);
      _this.map.fitBounds(geoJSONLayer.getBounds());
    });
  }
});
