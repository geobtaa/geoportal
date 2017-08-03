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

    var progress = document.getElementById('progress');
    var progressBar = document.getElementById('progress-bar');

    function updateProgressBar(processed, total, elapsed, layersArray) {
      if (elapsed > 1000) {
        // if it takes more than a second to load, display the progress bar:
        progress.style.display = 'block';
        progressBar.style.width = Math.round(processed/total*100) + '%';
      }

      if (processed === total) {
        // all markers processed - hide the progress bar:
        progress.style.display = 'none';
      }
    }

		var cluster = new L.markerClusterGroup({ chunkedLoading: true, chunkProgress: updateProgressBar });

    // Oboe - steam results
    // Select example: http://localhost:8983/solr/geoportal/select?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json
    // Export example: http://localhost:8983/solr/geoportal/export?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json&sort=dc_title_sdv%20asc
    oboe('http://localhost:8983/solr/geoportal/export?fl=uuid_sdv,dc_title_sdv,centroid_sdv&indent=on&q=*:*&wt=json&sort=dc_title_sdv%20asc')
      .node('response.docs.*', function( doc ){

          if(typeof doc.centroid_sdv != 'undefined'){
            var latlng = doc.centroid_sdv.split(",")

            // Create marker - adds title attribute
            var marker = L.marker(new L.LatLng(latlng[0],latlng[1]), { title: doc.dc_title_sdv });
            // Add popup and link to item
            marker.bindPopup("<a href='/catalog/" + doc.uuid_sdv + "'>" + doc.dc_title_sdv + "</a>");
            cluster.addLayer(marker);
          }

      // no need to handle update or exit set here since
      // downloading is purely additive
    });

    geoblacklight.map.addLayer(cluster);
  });
});
