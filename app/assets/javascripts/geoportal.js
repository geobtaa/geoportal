// B1G Geoportal Behaviors
$(document).ready(function() {
  $('a[data-js-fullscreen]').click(function(){
    screenfull.toggle($('#map')[0]);
  });

  if (screenfull.enabled) {
    screenfull.on('change', function() {
      if (screenfull.isFullscreen) {
        $('#map').addClass('fullscreen');
      } else {
        $('#map').removeClass('fullscreen');
      }
  	});
  }
});

$(window).load(function() {
  $('#viewer-container.well').removeClass('spinner');
});
