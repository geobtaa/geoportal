//= require geoblacklight/viewers/viewer

// @CUSTOMIZED
// - set initial bbox
GeoBlacklight.Viewer.Map = GeoBlacklight.Viewer.extend({

  options: {
    /**
    * Initial bounds of map
    * @type {L.LatLngBounds}
    */
    bbox: [[-20, -179], [64, 134]],
    opacity: 0.75,
    attributionControl: true
  },

  overlay: L.layerGroup(),
  markers: L.layerGroup(),

  load: function() {
    console.log('MAP: local and customized');

    if (this.data.mapGeom) {
      this.options.bbox = L.geoJSONToBounds(this.data.mapGeom);
    }
    this.map = L.map(this.element, { noWrap: true }).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    this.map.addLayer(this.markers);
    if (this.data.map !== 'index') {
      this.addBoundsOverlay(this.options.bbox);
    }

    // B1G Controls
    this.addFullscreenControl();
    this.addBasemapSwitcher();

    // Attribution Prefix
    this.map.attributionControl.setPrefix('Leaflet');
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
      ],
        {
          color: '#3388ff',
          dashArray: "5 5",
          weight: 2,
          opacity: 1,
          fillOpacity: 0
        }
      ));
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
   * Add a GeoJSON overlay to map.
   * @param {string} geojson GeoJSON string
   */
  addGeoJsonOverlay: function(geojson) {
    var layer = L.geoJSON();
    layer.addData(geojson);
    this.overlay.addLayer(layer);
  },

  /**
  * Selects basemap if specified in 1) cookie, 2) data options, 3) if not return mapquest
  */
  selectBasemap: function() {
    console.log("Selecting basemap");
    console.log("Cookie: " + Cookies.get('basemap'));

    var _this = this;
    if (Cookies.get('basemap')) {
      return GeoBlacklight.Basemaps[B1G.baseLayerMap[Cookies.get('basemap')]];
    } else if (_this.data.basemap) {
      return GeoBlacklight.Basemaps[_this.data.basemap];
    } else {
      return _this.basemap.mapquest;
    }
  },

  addFullscreenControl: function() {
    // fullscreen control
    console.log('Control: Fullscreen');
    this.map.addControl(new L.Control.Fullscreen({
      position: 'topleft'
    }));
  },

  addBasemapSwitcher: function() {
    // basemaps control
    console.log('Control: Base Layer');
    var baseLayers = {
      "Default (Esri)": GeoBlacklight.Basemaps.esri,
      "OpenStreetMap": GeoBlacklight.Basemaps.openstreetmapStandard,
      "World Imagery (Esri)": GeoBlacklight.Basemaps.esri_world_imagery
    };

    L.control.layers(baseLayers, null, { position: 'topleft' }).addTo(this.map);

    // Event listener for layer switcher
    this.map.on('baselayerchange', function (e) {
      Cookies.set('basemap', e.name)
    });
  },

  removeMarkers: function() {
    this.markers.clearLayers();
  },

  setHoverListeners: function() {
    $('[data-map="index"]').each(function(i, element) {
      $('#content')
        .on('mouseenter', '#documents [data-layer-id]', function() {
          var geom = $(this).data('geom')
          GeoBlacklight.Home.addGeoJsonOverlay(geom);
        })
        .on('mouseleave', '#documents [data-layer-id]', function() {
          GeoBlacklight.Home.removeBoundsOverlay();
      });
    });
  },

  placeMarkers: function() {
    // Clear existing markers
    GeoBlacklight.Home.removeMarkers();

    $('.document [data-geom]').each(function() {
      var _this = $(this),
          currentBbox = _this.data().geom,
          layerId = _this.data().layerId;
          counter = _this.data().counter,
          redMarker = L.ExtraMarkers.icon({
            innerHTML: '<p style="color: white; margin-top: 8px;">' + counter + '</p>',
            markerColor: 'blue',
            shape: 'square',
            prefix: 'fa'
          });

      if (currentBbox) {
        var bounds = L.geoJSONToBounds(currentBbox);
        var marker = L.marker(bounds.getCenter(), {icon: redMarker});

        // Add marker to map
        marker.addTo(GeoBlacklight.Home.markers);

        // Set scroll click event on marker
        marker.on('click', function() {
          console.log("Clicked - " + JSON.stringify(_this.offset()));
          $( ".document .selected" ).removeClass( "selected" );
          $('html, body').animate({scrollTop: _this.offset().top - 120}, 200);
          $( _this ).addClass( "selected" );
        });
      }
    });
  }
});
