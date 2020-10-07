//= require geoblacklight/viewers/esri

// populates attribute table with feature properties
var populateAttributeTable = function(feature) {
  var html = $('<tbody class="attribute-table-body"></tbody>');

  // step through properties and append to table
  for (var property in feature.properties) {
    if ( feature.properties[property] != null ) {
      html.append('<tr><td>' + property + '</td>'+
                  '<td>' + GeoBlacklight.Util.linkify(feature.properties[property]) + '</tr>');
    }
  }
  $('.attribute-table-body').replaceWith(html);
}

GeoBlacklight.Viewer.FeatureLayer = GeoBlacklight.Viewer.Esri.extend({

  // default feature styles
  defaultStyles: {
    'esriGeometryPoint': '',
    'esriGeometryMultipoint': '',
    'esriGeometryPolyline': {color: 'blue', weight: 3 },
    'esriGeometryPolygon': {color: 'blue', weight: 2 }
  },

  getPreviewLayer: function() {

    // set layer url
    this.options.url = this.data.url;

    // set default style
    this.options.style = this.getFeatureStyle();

    // set pointToLayer
    this.options.pointToLayer = function (geojson, latlng) {
      return L.marker(latlng, {
      }).on('click', function(e) {
        populateAttributeTable(geojson);
      });
    }

    // define feature layer
    this.esriFeatureLayer = L.esri.Cluster.featureLayer(this.options);

    //setup feature inspection and opacity
    this.setupInspection(this.esriFeatureLayer);
    this.setupInitialOpacity(this.esriFeatureLayer);

    return this.esriFeatureLayer;
  },

  controlPreload: function() {

    // define setOpacity function that works for svg elements
    this.esriFeatureLayer.setOpacity = function(opacity) {
      $('.leaflet-clickable').css({ opacity: opacity });
    };
  },

  getFeatureStyle: function() {
    var _this = this;

    // lookup style hash based on layer geometry type and return function
    return function(feature) {
      return _this.defaultStyles[_this.layerInfo.geometryType];
    };
  },

  setupInitialOpacity: function(featureLayer) {
    featureLayer.on('load', function(e) {
      featureLayer.setOpacity(this.options);
    });
  },

  setupInspection: function(featureLayer) {
    var _this = this;

    // inspect on click
    featureLayer.on('click', function(e) {
      var distance = 3000 / (1 + _this.map.getZoom());

      _this.appendLoadingMessage();

      // query layer at click location
      featureLayer.query()
      .returnGeometry(false)
      .nearby(e.latlng, distance)
      .run(function(error, featureCollection, response) {
        if (error || response['features'] < 1) {
          _this.appendErrorMessage();
        } else {
          _this.populateAttributeTable(featureCollection.features[0]);
        }
      });
    });
  }
});
