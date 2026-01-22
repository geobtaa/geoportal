// VanillaJS Ready
document.addEventListener('DOMContentLoaded', function() {
  // Datepickers - YYYY-MM-DD
  if($("input[data-js='datepicker']").length > 0) {
    $("input[data-js='datepicker']").datepicker({
      language: 'en',
      format: 'yyyy-mm-dd',
      'autoclose': true
    });
  }

  // Datepickers - YYYY
  if($("input[data-js='datepicker-years']").length > 0) {
    $("input[data-js='datepicker-years']").datepicker({
      language: 'en',
      format: 'yyyy',
      viewMode: "years",
      minViewMode: "years",
      'autoclose': true
    });
  }
});
