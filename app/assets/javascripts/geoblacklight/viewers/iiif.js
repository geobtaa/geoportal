//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.Iiif = GeoBlacklight.Viewer.extend({
  load: function() {
    this.adjustLayout();
    // @CUSTOMIZED - Fullscreen suppport
    // http://brunob.github.io/leaflet.fullscreen/
    this.map = L.map(this.element, {
      center: [0, 0],
      crs: L.CRS.Simple,
      zoom: 0,
      fullscreenControl: true
    });
    this.loadControls();
    this.iiifLayer = L.tileLayer.iiif(this.data.url)
      .addTo(this.map);
  },

  adjustLayout: function() {

    // hide attribute table
    $('#table-container').hide();

    // expand viewer element
    $(this.element).parent().attr('class', 'col-md-12');
  }
});
