/*global GeoBlacklight */

// base viewer
GeoBlacklight.Viewer = L.Class.extend({
  options: {},

  initialize: function(el, options) {
    this.element = el;
    this.data = $(el).data();

    L.Util.setOptions(this, options);

    // test network
    this.displayLayerLoading();
    this.testNetwork();

    // trigger viewer load functions
    this.load();
  },

  /**
  * Loads leaflet controls from controls directory.
  **/
  loadControls: function() {
    var _this = this;
    var protocol = this.data.protocol.toUpperCase();
    var options = this.data.leafletOptions;

    if (!options.VIEWERS) {
      return;
    }

    var viewer = options.VIEWERS[protocol];
    var controls = viewer && viewer.CONTROLS;

    _this.controlPreload();

    /**
    * Loop though the GeoBlacklight.Controls hash, and for each control,
    * check to see if it is included in the controls list for the current
    * viewer. If it is, then pass in the viewer object and run the function
    * that adds it to the map.
    **/
    $.each(GeoBlacklight.Controls, function(name, func) {
      if (controls && controls.indexOf(name) > -1) {
        func.call(_this);
      }
    });
  },

  /**
  * Work to do before the controls are loaded.
  **/
  controlPreload: function() {
    return;
  },

  /**
  * Gets the value of detect retina from application settings.
  **/
  detectRetina: function() {
    var options = this.data.leafletOptions;
    if (options && options.LAYERS) {
      return options.LAYERS.DETECT_RETINA ? options.LAYERS.DETECT_RETINA : false;
    } else {
      return false;
    }
  },

  // Check the data url to see if CORS or http (non-secure) error exists
  testNetwork: function() {
    var _this = this;

    $.ajax(this.data.url, {
      success: function() {
        _this.displayLayerSuccess();
      },
      error: function() {
        _this.displayLayerError();
      }
    });
  },

  // Warn the user the web service is unavailable
  displayLayerError: function() {
    $('.help-text.viewer_protocol span').remove()

    $('#map').append(
      "<div id='esri-error'>" +
        "<div class='content'>" +
          "<h3>Our Apologies</h3>" +
          "<h4>A web service preview for this map is unavailable.</h4>" +
        "</div>" +
      "</div>"
    );

    $('#attribute-table').hide();

    // Log all item viewer errors
    window._gaq.push(['_trackEvent', 'Item Viewer Error', window.location.href.split("/").pop()]);
  },

  // Add badge for layer data loading
  displayLayerLoading: function() {
    $('.help-text.viewer_protocol span').remove()
    $('.help-text.viewer_protocol').append(
    "<span class='float-right badge badge-warning'>" + "Data Loading" +'</span>'
    )
  },

  // Success remove any badges
  displayLayerSuccess: function() {
    $('.help-text.viewer_protocol span').fadeTo(4000, 0.01, function(){
        $(this).slideUp(150, function() {
            $(this).remove();
        });
    });
  }
});
