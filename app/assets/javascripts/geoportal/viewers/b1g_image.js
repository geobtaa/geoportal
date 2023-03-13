//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.B1gImage = GeoBlacklight.Viewer.extend({
  load: function() {
    this.map = this.map = L.map(this.element, {
      center: [0, 0],
      crs: L.CRS.Simple,
      zoom: 0,
      zoomControl:false,
      sleep: false
    });

    this.loadControls();

    var img = document.createElement("img");

    img.setAttribute("src", this.data.url);
    img.setAttribute("class", "col-lg-12");
    img.setAttribute("style", "height: auto; width: auto");
    img.setAttribute("data-viewer", 'b1g_image');
    document.getElementById("map").appendChild(img);
  }
});
