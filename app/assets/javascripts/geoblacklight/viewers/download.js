//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.Download = GeoBlacklight.Viewer.extend({
  load: function() {
    this.map = this.map = L.map(this.element, {
      center: [0, 0],
      crs: L.CRS.Simple,
      zoom: 0,
      zoomControl:false
    });

    this.loadControls();

    var img = document.createElement("img");

    img.setAttribute("src", this.data.url);
    img.setAttribute("class", "img-fluid col-lg-12");
    img.setAttribute("data-viewer", 'download');
    document.getElementById("map").appendChild(img);
  }
});
