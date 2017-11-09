//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.Download = GeoBlacklight.Viewer.extend({
  load: function() {
    this.map = this.element

    var img = document.createElement("img");
    var parser = document.createElement("a");
    parser.href = this.data.url;

    var collectionRegex = /collection\/(.+)\/id/g
    var collection = collectionRegex.exec(parser.pathname);
    console.log(collection[1]);

    var idRegex = /id\/(.+)\/type/g
    var id = idRegex.exec(parser.pathname);
    console.log(id[1]);

    var img_url = "";
    var img_url = img_url.concat(parser.protocol);
    var img_url = img_url.concat(parser.hostname);
    var img_url = img_url.concat('/utils/ajaxhelper/?CISOROOT=');
    var img_url = img_url.concat(collection[1]);
    var img_url = img_url.concat('&CISOPTR=');
    var img_url = img_url.concat(id[1]);
    var img_url = img_url.concat('&action=2&DMSCALE=25&DMWIDTH=5000&DMHEIGHT=5000&DMX=0&DMY=0&DMTEXT=&DMROTATE=0');

    // Example: https://collection1.libraries.psu.edu/utils/ajaxhelper/?CISOROOT=maps1&CISOPTR=30130&action=2&DMSCALE=15&DMWIDTH=1200&DMHEIGHT=1200&DMX=0&DMY=0&DMTEXT=&DMROTATE=0
    img.setAttribute("src", img_url);
    img.setAttribute("class", "img-responsive col-lg-12");
    document.getElementById("map").appendChild(img);
  }
});
