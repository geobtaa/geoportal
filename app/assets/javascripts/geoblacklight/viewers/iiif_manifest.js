//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.IiifManifest = GeoBlacklight.Viewer.extend({
  load: function() {
    var manifest_uri = document.getElementById('iiif_manifest').getAttribute('data-url');

    var miradorInstance = Mirador.viewer({
       id: 'map',
       windows: [{
         manifestId: manifest_uri,
         canvasIndex: 2,
         thumbnailNavigationPosition: 'far-bottom',
       }],
       window: {
         hideSearchPanel: false,
       },
       workspaceControlPanel: {
         enabled: false,
       }
     });
  }
});
