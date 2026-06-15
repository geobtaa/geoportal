// Fields - JS Behaviors

// Disable Field if Persisted
GBLADMIN.DisableIfPersisted = function() {
  if($('[data-persisted="true"]').length > 0) {
    elms = $('[data-js="disable_if_persisted"]');
    elms.each(function(i) {
      $(this).prop( "disabled", true );
    });
  }
}