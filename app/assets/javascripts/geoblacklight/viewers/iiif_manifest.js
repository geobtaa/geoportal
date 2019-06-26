//= require geoblacklight/viewers/viewer

GeoBlacklight.Viewer.IiifManifest = GeoBlacklight.Viewer.extend({
  load: function() {
    var manifest_uri = document.getElementById('iiif_manifest').getAttribute('data-url');

    var miradorInstance = Mirador.viewer({
       id: 'map',
       themes: {
         light: {
           palette: {
             type: 'light',
             primary: {
               main: '#0088ce',
             },
           },
         },
       },
       windows: [{
         manifestId: manifest_uri,
         canvasIndex: 2,
         thumbnailNavigationPosition: 'far-bottom',
       }],
       window: {
         hideSearchPanel: false,
         hideWindowTitle: true,
         hideAnnotationsPanel: true,
         allowClose: false,
         allowMaximize: false,
         allowFullscreen: true,
       },
       workspace: {
         showZoomControls: true,
       },
       workspaceControlPanel: {
         enabled: false,
       }
     });
  }
});
