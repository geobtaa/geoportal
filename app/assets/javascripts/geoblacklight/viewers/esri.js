//= require geoblacklight/viewers/map

GeoBlacklight.Viewer.Esri = GeoBlacklight.Viewer.Map.extend({
  layerInfo: {},

  load: function() {
    this.displayLayerLoading();
    this.options.bbox = L.bboxToBounds(this.data.mapBbox);
    this.map = L.map(this.element).fitBounds(this.options.bbox);
    this.map.addLayer(this.selectBasemap());
    this.map.addLayer(this.overlay);
    this.testNetwork();

    if (this.data.available) {
      this.getEsriLayer();
    } else {
      this.addBoundsOverlay(this.options.bbox);
    }
  },

  // Check the data url to see if CORS or http (non-secure) error exists
  testNetwork: function() {
    var _this = this;
    xhr = new XMLHttpRequest();
    xhr.onerror = (error) => this.displayLayerError();
    xhr.open('GET', _this.data.url);
    xhr.send();
  },

  // Warn the user the web service is unavailable
  displayLayerError: function(error_message = '') {
    $('.help-text.viewer_protocol span').remove()

    $('.help-text.viewer_protocol').append(
      "<span class='float-right badge badge-danger'>" + "Network Error" + error_message + '</span>'
    );

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
    $('.help-text.viewer_protocol span').remove()
  },

  getEsriLayer: function() {
    var _this = this;

    // remove any trailing slash from endpoint url
    _this.data.url = _this.data.url.replace(/\/$/, '');
    L.esri.get(_this.data.url, {}, function(error, response){
      if(error) {
        _this.displayLayerError(" - " + error.message);
        console.log(error);
      }
      else {
        _this.layerInfo = response;

        // get layer as defined in submodules (e.g. esri/mapservice)
        var layer = _this.getPreviewLayer();

        // add layer to map
        if (_this.addPreviewLayer(layer)) {
          // add controls if layer is added
          _this.loadControls();
        }
      }
    });
  },

  addPreviewLayer: function(layer) {
    // if not null, add layer to map
    if (layer) {

      this.overlay.addLayer(layer);
      this.displayLayerSuccess();
      return true;
    }
  },

  // clear attribute table and setup spinner icon
  appendLoadingMessage: function() {
    var spinner = '<tbody class="attribute-table-body"><tr><td colspan="2">' +
      '<span id="attribute-table">' +
      '<i class="fa fa-spinner fa-spin fa-align-center">' +
      '</i></span>' +
      '</td></tr></tbody>';

    $('.attribute-table-body').html(spinner);
  },

  // appends error message to attribute table
  appendErrorMessage: function() {
    $('.attribute-table-body').html('<tbody class="attribute-table-body">'+
      '<tr><td colspan="2">Could not find that feature</td></tr></tbody>');
  },

  // populates attribute table with feature properties
  populateAttributeTable: function(feature) {
    var html = $('<tbody class="attribute-table-body"></tbody>');

    // step through properties and append to table
    for (var property in feature.properties) {
      html.append('<tr><td>' + property + '</td>'+
                  '<td>' + GeoBlacklight.Util.linkify(feature.properties[property]) + '</tr>');
    }
    $('.attribute-table-body').replaceWith(html);
  }
});
