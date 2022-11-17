Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {

    var geoblacklight = new GeoBlacklight.Viewer.Map(this),
        data = $(this).data();

    console.log('Map: Home')

    geoblacklight.map.setZoom(2);
    geoblacklight.map.addControl(L.control.geosearch({
      baseUrl: '/',
      dynamic: false,
      searcher: function() {
        window.location.href = this.getSearchUrl();
      },
      staticButton: '<a href="#" id="map-search-btn" class="btn btn-primary hidden-xs hidden-sm">Search here</a>'
    }));

    // B1G Customizations
    // B1G Controls
    // leaflet-geosearch
    var GeoSearchControl = window.GeoSearch.GeoSearchControl;
    var OpenStreetMapProvider = window.GeoSearch.OpenStreetMapProvider;
    var provider = new OpenStreetMapProvider();
    var searchControl = new GeoSearchControl({
      position: 'topleft',
      provider: provider,
    });
    geoblacklight.map.addControl(searchControl);

    var progress = document.getElementById('progress');
    var progressBar = document.getElementById('progress-bar');

    function updateProgressBar(processed, total, elapsed, layersArray) {
      if (elapsed > 100) {
        // if it takes more than a second to load, display the progress bar:
        progress.style.display = 'block';
        progressBar.style.width = Math.round(processed/total*100) + '%';
      }

      if (processed === total) {
        // all markers processed - hide the progress bar:
        progress.style.display = 'none';
      }
    }

    var pruneCluster = new PruneClusterForLeaflet();

    // Oboe - SAX steam JSON results from Solr /export
    // oboe('http://localhost:8983/solr/geoportal/export?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json&sort=dc_title_sdv%20asc&rows=10000')

    oboe('/centroids.json')
      .node('*', function( doc ){
          if(typeof doc.c != 'undefined'){
            var latlng = doc.c.split(",")

            var marker = new PruneCluster.Marker(latlng[0],latlng[1], {popup: "<a href='/catalog/" + doc.l + "'>" + doc.t + "</a>"});
            pruneCluster.RegisterMarker(marker);
          }
        }
      )
      .done(function(){
        geoblacklight.map.addLayer(pruneCluster)
      })
  });
});
