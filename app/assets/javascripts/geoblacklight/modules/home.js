Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {

    var geoblacklight = new GeoBlacklight.Viewer.Map(this),
        data = $(this).data();

    geoblacklight.map.addControl(L.control.geosearch({
      baseUrl: data.catalogPath,
      dynamic: false,
      searcher: function() {
        window.location.href = this.getSearchUrl();
      },
      staticButton: '<a class="btn btn-primary">Search here</a>'
    }));

    var pruneCluster = new PruneClusterForLeaflet();

    // Oboe - SAX steam JSON results from Solr /export
    // oboe('http://localhost:8983/solr/geoportal/export?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json&sort=dc_title_sdv%20asc&rows=10000')
    oboe('/centroids.json')
      .node('*', function( doc ){
          if(typeof doc.b1g_centroid_ss != 'undefined'){
            var latlng = doc.b1g_centroid_ss.split(",")
            var marker = new PruneCluster.Marker(latlng[0],latlng[1], {popup: "<a href='/catalog/" + doc.layer_slug_s + "'>" + doc.dc_title_s + "</a>"});
            pruneCluster.RegisterMarker(marker);
          }
        }
      )
      .done(function(){
        geoblacklight.map.addLayer(pruneCluster);
      })
  });
});
