//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.Download = GeoBlacklight.Viewer.extend({
  load: function() {
    this.map = this.element

    console.log(this.data.url);

    var img = document.createElement("img");

    img.setAttribute("src", this.data.url);
    img.setAttribute("class", "img-responsive col-lg-12");
    img.setAttribute("data-viewer", 'download');
    document.getElementById("map").appendChild(img);
  }
});
