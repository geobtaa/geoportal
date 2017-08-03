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

    // Fetch data
    $.ajax({
        url: 'http://localhost:8983/solr/geoportal/select',
        cache: true,
        dataType: 'JSONP',
        data: {
          q: '*:*',
          rows: 10000,
          fl: 'uuid_sdv,dc_title_sdv,centroid_sdv',
          wt: 'json'
        },
        jsonp: 'json.wrf',
        success: function(data) {
          console.log(data.response.docs);
          $.each(data.response.docs, function(i, val) {
            if(typeof val.centroid_sdv != 'undefined'){
              var latlng = val.centroid_sdv.split(",")

              // Create marker - adds title attribute
              var marker = L.marker(new L.LatLng(latlng[0],latlng[1]), { title: val.dc_title_sdv });
              // Add popup and link to item
              marker.bindPopup("<a href='/catalog/" + val.uuid_sdv + "'>" + val.dc_title_sdv + "</a>");
              cluster.addLayer(marker);
            }
          });
        }
    });

    geoblacklight.map.addLayer(cluster);

  });
});
