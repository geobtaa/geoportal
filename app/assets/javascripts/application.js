// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require rails-ujs
//
// Required by Blacklight
//= require jquery
//= require blacklight/blacklight

// Required by GeoBlacklight
//= require handlebars.runtime
//= require geoblacklight/geoblacklight
//= require geoblacklight/viewers/viewer
//= require Leaflet/leaflet.fullscreen/Control.FullScreen.js
//= require Leaflet/leaflet.prunecluster/PruneCluster.js
//= require oboe/oboe-browser.js

//= require_tree .

// @CUSTOMIZED
// - disabled scroll wheel zoom
// - set initial bbox
GeoBlacklight.Viewer.Map = GeoBlacklight.Viewer.extend({

  options: {
    /**
    * Initial bounds of map
    * @type {L.LatLngBounds}
    */
    bbox: [[-20, -179], [64, 134]],
    opacity: 0.75
  },

  overlay: L.layerGroup(),

  load: function() {
    if (this.data.mapBbox) {
      this.options.bbox = L.bboxToBounds(this.data.mapBbox);
    }
    this.map = L.map(this.element, {scrollWheelZoom:false, noWrap: true}).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    if (this.data.map !== 'index') {
      this.addBoundsOverlay(this.options.bbox);
    }
  },

  /**
   * Add a bounding box overlay to map.
   * @param {L.LatLngBounds} bounds Leaflet LatLngBounds
   */
  addBoundsOverlay: function(bounds) {
    if (bounds instanceof L.LatLngBounds) {
      this.overlay.addLayer(L.polygon([
        bounds.getSouthWest(),
        bounds.getSouthEast(),
        bounds.getNorthEast(),
        bounds.getNorthWest()
      ]));
    }
  },

  /**
   * Remove bounding box overlay from map.
   */
  removeBoundsOverlay: function() {
    this.overlay.clearLayers();
  },

  /**
   * Add an opacity control to map.
   */
  addOpacityControl: function() {
    this.map.addControl(new L.Control.LayerOpacity(this.overlay));
  },

  /**
  * Selects basemap if specified in data options, if not return mapquest
  */
  selectBasemap: function() {
    var _this = this;
    if (_this.data.basemap) {
      return GeoBlacklight.Basemaps[_this.data.basemap];
    } else {
      return _this.basemap.mapquest;
    }
  }
});
