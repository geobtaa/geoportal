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
    opts = { baseUrl: '/' },
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
    GeoBlacklight.Home = new GeoBlacklight.Viewer.Map(this, { bbox: bbox });

    // set hover listeners on map
    $('#content')
      .on('mouseenter', '#documents [data-layer-id]', function() {
        if($(this).data('bbox') !== "") {
          var geom = $(this).data('geom')
          GeoBlacklight.Home.addGeoJsonOverlay(geom)
        }
      })
      .on('mouseleave', '#documents [data-layer-id]', function() {
        GeoBlacklight.Home.removeBoundsOverlay();
      });

    // add geosearch control to map
    GeoBlacklight.Home.map.addControl(L.control.geosearch(opts));

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
    GeoBlacklight.Home.map.addControl(searchControl);

    // Set document markers
    GeoBlacklight.Home.placeMarkers();
    GeoBlacklight.Home.setHoverListeners();
  });

  function setHoverListeners() {
    $('[data-map="index"]').each(function(i, element) {
      $('#content')
        .on('mouseenter', '#documents [data-layer-id]', function() {
          var geom = $(this).data('geom')
          GeoBlacklight.Home.addGeoJsonOverlay(geom);
        })
        .on('mouseleave', '#documents [data-layer-id]', function() {
          GeoBlacklight.Home.removeBoundsOverlay();
      });
    });
  }

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

      // Reload markers and listeners
      GeoBlacklight.Home.placeMarkers();
      GeoBlacklight.Home.setHoverListeners()
    });
  }
});
