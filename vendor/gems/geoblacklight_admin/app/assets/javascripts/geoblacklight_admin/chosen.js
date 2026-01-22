// VanillaJS Ready
// @TODO: Replace with Tom Select
document.addEventListener('DOMContentLoaded', function() {
  var elements = document.querySelectorAll('.chosen-select');
  Array.prototype.forEach.call(elements, function(el, i){
    console.log("Vanilla JS Chosen Select");
    $('.chosen-select').chosen();
  });
});
