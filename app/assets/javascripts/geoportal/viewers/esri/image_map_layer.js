GeoBlacklight.Viewer.ImageMapLayer = GeoBlacklight.Viewer.Esri.extend({
  layerInfo: {},

  getPreviewLayer: function() {
    var _this = this;

    // set layer url
    this.options.url = this.data.url;

    // return image service layer
    var layer = new L.esri.imageMapLayer(this.options);

    layer.on("loading", function (e) {
      _this.displayLayerLoading();
    });

    return layer;
  }
});
