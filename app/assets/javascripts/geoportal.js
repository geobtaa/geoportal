// B1G Geoportal Behaviors
$(document ).ready(function() {
  $('a[data-js-fullscreen]').click(function(){
    screenfull.toggle($('#map')[0]);
    $('#map').toggleClass("fullscreen");
  });
});
