Blacklight.onLoad(function() {
  $('[data-map="home"]').each(function(i, element) {

    var geoblacklight = new GeoBlacklight.Viewer.Map(this),
        data = $(this).data();

    geoblacklight.map.setZoom(2);
    geoblacklight.map.addControl(L.control.geosearch({
      baseUrl: data.catalogPath,
      dynamic: false,
      searcher: function() {
        window.location.href = this.getSearchUrl();
      },
      staticButton: '<a id="map-search-btn" class="btn btn-primary hidden-xs hidden-sm">Search here</a>'
    }));

    var markers = L.markerClusterGroup();

    // Oboe - SAX steam JSON results from Solr /export
    // oboe('http://localhost:8983/solr/geoportal/export?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json&sort=dc_title_sdv%20asc&rows=10000')
    oboe('/centroids.json')
      .node('*', function( doc ){
          if(typeof doc.b1g_centroid_ss != 'undefined'){
            var latlng = doc.b1g_centroid_ss.split(",")
            markers.addLayer(L.marker([latlng[0],latlng[1]]).bindPopup("<a href='/catalog/" + doc.layer_slug_s + "'>" + doc.dc_title_s + "</a>"));
          }
        }
      )
      .done(function(){
        geoblacklight.map.addLayer(markers);
      })
  });
});
