//= require geoblacklight/viewers/esri

GeoBlacklight.Viewer.DynamicMapLayer = GeoBlacklight.Viewer.Esri.extend({

  // override to parse between dynamic layer types
  getEsriLayer: function() {
    var _this = this;

    // remove any trailing slash from endpoint url
    _this.data.url = _this.data.url.replace(/\/$/, '');

    // get last segment from url
    var pathArray = this.data.url.replace(/\/$/, '').split('/');
    var lastSegment = pathArray[pathArray.length - 1];

    // if the last seg is an integer, slice and save as dynamicLayerId
    if (Number(lastSegment) === parseInt(lastSegment, 10)) {
      this.dynamicLayerId = lastSegment;
      this.data.url = this.data.url.slice(0,-(lastSegment.length + 1));
    }

    L.esri.get = L.esri.Request.get.JSONP;
    L.esri.get(_this.data.url, {}, function(error, response){
      if(!error) {
        _this.layerInfo = response;

        //if there's not a single specified layer,
        //check for visible layers and use those,
        //otherwise, just use the first one :/
        if (!_this.dynamicLayerId){
            var all_layers = _this.layerInfo.layers;
            var all_layers_ids = [];
            var visible_layers = [];
            $(all_layers).each(function(index, lyr){
                if (lyr.defaultVisibility === true){
                    visible_layers.push(lyr.id);
                }
                all_layers_ids.push(lyr.id);
            });

            if (visible_layers.length > 0){
                _this.dynamicLayerIds = visible_layers;
            }
            else {
                _this.dynamicLayerIds = all_layers_ids[0];
            }
        }

        // get layer
        var layer = _this.getPreviewLayer();

        // add layer to map
        if (_this.addPreviewLayer(layer)) {

          // add control if layer is added
          _this.addOpacityControl();
        }
      }
    });
  },

  getPreviewLayer: function() {

    // set layer url
    this.options.url = this.data.url;

    //is there a way to check for CORS support
    //and only set false if necessary?
    //for now we need JSONP
    this.options.useCors = false;

    // show only single layer, if specified
    if (this.dynamicLayerId) {
      this.options.layers = [this.dynamicLayerId];
    }
    else if (this.dynamicLayerIds){
      this.options.layers = this.dynamicLayerIds;
    }

    var esriDynamicMapLayer = L.esri.dynamicMapLayer(this.options);

    // setup feature inspection
    this.setupInspection(esriDynamicMapLayer);
    return esriDynamicMapLayer;
  },

  setupInspection: function(layer) {
    var _this = this;
    this.map.on('click', function(e) {
      _this.appendLoadingMessage();
      var layers = _this.dynamicLayerId ? "all:" + _this.dynamicLayerId :
        _this.dynamicLayerIds ? "all:" + _this.dynamicLayerIds.join() : "top";
      layer.identify()
        .on(_this.map)
        .layers(layers)
        .at(e.latlng)
        .tolerance(2)
        .returnGeometry(false)
        .run(function(error, featureCollection){
          if (error) {
            _this.appendErrorMessage();
          }
          else if (featureCollection.features.length > 0) {
            _this.populateAttributeTable(featureCollection.features[0]);
          }
          else {
            _this.appendNoFeatureFoundMessage();
          }
        });
       });
  }
});
