Blacklight.onLoad(function () {
  'use strict';

  $('[data-map="index"]').each(function () {
    BlacklightHeatmaps.indexView(this, {});
  });
});

!(function (global) {
  'use strict';

  var IndexView = L.Class.extend({
    options: {},

    initialize: function (el, options) {
      var _this = this;
      var $el = $(el);
      var requestUrl = $el.data().searchUrl + '&format=json';
      var geometryField = $el.data().geometryField;
      var template = $el.data().sidebarTemplate;
      var colorRamp = $el.data().colorRamp;

      // Blank out page link content first and disable pagination
      $('#sortAndPerPage .page_links').html('');
      $('ul.pagination li').addClass('disabled');

      var map = L.map($el[0].id).setView([0, 0], 1);
      var basemap = BlacklightHeatmaps.selectBasemap(
        $el.data().basemapProvider
      ).addTo(map);

      var solrLayer = L.solrHeatmap(requestUrl, {
        field: geometryField,
        maxSampleSize: 50,
        colors: colorRamp,
      }).addTo(map);

      var sidebar = L.control.sidebar('index-map-sidebar', {
        position: 'right',
      });

      map.addControl(sidebar);

      solrLayer.on('click', function (e) {
        if (!sidebar.isVisible()) {
          map.setView(e.latlng);
        } else {
          var point = map.project(e.latlng);
          var offset = sidebar.getOffset();
          var newPoint = L.point(point.x - (offset / 2), point.y);
          map.setView(map.unproject(newPoint));
        }

        sidebar.show();
      });

      solrLayer.on('dataAdded', function (e) {
        if (e.response && e.response.docs) {
          var html = '';

          $.each(e.response.docs, function (i, value) {
            html += L.Util.template(template, value);
          });

          sidebar.setContent(html);

          var docCount = e.response.pages.total_count;
          $('#sortAndPerPage .page_links').html(
            parseInt(docCount).toLocaleString() + ' ' +
            _this.pluralize(docCount, 'item') + ' found'
          );
        }
      });

      $(document).on('turbolinks:click', function (e) {
        e.preventDefault();
      });
    },

    pluralize: function (count, word) {
      switch (count) {
        case 1:
          return word;
        default:
          return word + 's';
      }
    },
  });

  global.BlacklightHeatmaps.IndexView = IndexView;
  global.BlacklightHeatmaps.indexView = function (el, options) {
    return new IndexView(el, options);
  };
})(this);
