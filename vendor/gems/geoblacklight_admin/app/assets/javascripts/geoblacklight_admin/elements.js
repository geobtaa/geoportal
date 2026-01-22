GBLADMIN.SortElements = function(elm_container, change_url) {
  console.log("Behavior added: Sort elements init")
  var container, sort_lists;
  container = $(elm_container);

  container.sortable({
    cursor: "pointer",
    items: "> tr",
    appendTo: "parent",
    helper: "original",
    handle: ".handle",
    axis: "y"
  });

  container.on('sortupdate', function() {
    console.log("Sorting");
    var active_id_list, element;

    element = $(this);
    console.log(element);

    active_id_list = $.map(
      $(this).find('tr'), function (e) {
        return $(e).data('id');
      }
    );

    console.log(active_id_list);
    console.log(change_url);

    $.post(
      change_url,
      {
        'id_list[]': active_id_list,
      }
    );
  });
};
