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

    // Oboe - steam results
    // Select example: http://localhost:8983/solr/geoportal/select?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json
    // Export example: http://localhost:8983/solr/geoportal/export?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json&sort=dc_title_sdv%20asc
    oboe('http://localhost:8983/solr/geoportal/export?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json&sort=dc_title_sdv%20asc&rows=10000')
      .node('response.docs.*', function( doc ){

          if(typeof doc.centroid_sdv != 'undefined'){
            var latlng = doc.centroid_sdv.split(",")

            // console.log("Add: marker" + latlng[0] + "," + latlng[1])
            // Create marker - adds title attribute
            var marker = new PruneCluster.Marker(latlng[0],latlng[1], {popup: "<a href='/catalog/" + doc.uuid_sdv + "'>" + doc.dc_title_sdv + "</a>"});
            // Add popup and link to item
            // marker.data.popup("<a href='/catalog/" + doc.uuid_sdv + "'>" + doc.dc_title_sdv + "</a>");
            pruneCluster.RegisterMarker(marker);
          }
        }
      )
      .done(function(){
        geoblacklight.map.addLayer(pruneCluster);
      })
      // no need to handle update or exit set here since
      // downloading is purely additive
  });
});
