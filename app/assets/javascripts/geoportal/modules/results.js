Blacklight.onLoad(function() {
  var historySupported = !!(window.history && window.history.pushState);

  if (historySupported) {
    History.Adapter.bind(window, 'statechange', function() {
      var state = History.getState();
      updatePage(state.url);
    });
  }

  $('[data-map="index"]').each(function() {
    var data = $(this).data(),
    opts = { baseUrl: data.catalogPath },
    world = L.latLngBounds([[-90, -180], [90, 180]]),
    geoblacklight, bbox;

    if (typeof data.mapGeom === 'string') {
      bbox = L.geoJSONToBounds(data.mapGeom);
    } else {
      $('.document [data-geom]').each(function() {
        try {
          var currentBounds = L.geoJSONToBounds($(this).data().geom);
          if (!world.contains(currentBounds)) {
            throw "Invalid bounds";
          }
          if (typeof bbox === 'undefined') {
            bbox = currentBounds;
          } else {
            bbox.extend(currentBounds);
          }
        } catch (e) {
          bbox = L.bboxToBounds("-180 -90 180 90");
        }
      });
    }

    if (!historySupported) {
      $.extend(opts, {
        dynamic: false,
        searcher: function() {
          window.location.href = this.getSearchUrl();
        }
      });
    }

    // instantiate new map
    geoblacklight = new GeoBlacklight.Viewer.Map(this, { bbox: bbox });

    var markers = L.markerClusterGroup();

    // Send Oboe to admin/api for non-web-ui attributes like centroid
    // Not usingURL() to maintain legacy IE support
    url = document.createElement('a');
    url.href = window.location.href;
    url.pathname = '/admin/api.json'
    // Oboe - Re-query Solr for JSON results
    oboe(url.toString() + '&format=json&per_page=500&rows=500')
      .node('data.*', function( doc ){
          if(typeof doc['attributes']['dcat_centroid_ss'] != 'undefined'){
            var latlng = doc['attributes']['dcat_centroid_ss']['attributes']['value'].split(",")
            markers.addLayer(L.marker([latlng[0],latlng[1]]).bindPopup("<a href='/catalog/" + doc['attributes']['geomg_id_s']['attributes']['value'] + "'>" + doc['attributes']['dct_title_s']['attributes']['value'] + "</a>"));
          }
        }
      )
      .done(function(){
        geoblacklight.map.addLayer(markers);
      })

    // set hover listeners on map
    $('#content')
      .on('mouseenter', '#documents [data-layer-id]', function() {
        if($(this).data('bbox') !== "") {
          var geom = $(this).data('geom')
          geoblacklight.addGeoJsonOverlay(geom)
        }
      })
      .on('mouseleave', '#documents [data-layer-id]', function() {
        geoblacklight.removeBoundsOverlay();
      });

    // add geosearch control to map
    geoblacklight.map.addControl(L.control.geosearch(opts));

    // B1G Customizations
    // fullscreen control
    // basemaps control

    // leaflet-geosearch
    var GeoSearchControl = window.GeoSearch.GeoSearchControl;
    var OpenStreetMapProvider = window.GeoSearch.OpenStreetMapProvider;
    var provider = new OpenStreetMapProvider();
    var searchControl = new GeoSearchControl({
      provider: provider,
    });
    geoblacklight.map.addControl(searchControl);
  });

  function updatePage(url) {
    $.get(url).done(function(data) {
      var resp = $.parseHTML(data);
      $doc = $(resp);
      $('#documents').replaceWith($doc.find('#documents'));
      $('#sidebar').replaceWith($doc.find('#sidebar'));
      $('#sortAndPerPage').replaceWith($doc.find('#sortAndPerPage'));
      $('#appliedParams').replaceWith($doc.find('#appliedParams'));
      $('#pagination').replaceWith($doc.find('#pagination'));
      if ($('#map').next().length) {
        $('#map').next().replaceWith($doc.find('#map').next());
      } else {
        $('#map').after($doc.find('#map').next());
      }
    });
  }
});
