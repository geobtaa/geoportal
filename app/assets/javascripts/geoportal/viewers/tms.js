GeoBlacklight.Viewer.Tms = GeoBlacklight.Viewer.Wms.extend({

  addPreviewLayer: function() {
    var _this = this;
    var wmtsLayer = L.tileLayer(this.data.url);
    this.overlay.addLayer(wmtsLayer);
  }
});
