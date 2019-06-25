// B1G Geoportal Behaviors
$(document).ready(function() {
  $(function () {
    $('[data-toggle="popover"]').popover({
      trigger: 'hover'
    })
  })
});

// @TODO - Breaks in GBL 2.0
/* $(window).load(function() {
  $('#viewer-container.well').removeClass('spinner');
});*/
