// Structure:
// Select All button must have class 'select2-select-all' and have the data attributes:
//    select-id: The ID of the select2 field
//    select-all-path: A path to a controller method that returns all select options in a hash formatted to JSON (Ex. [{"id":#,"text":"..."},{...}])
//
// Clear All button must have class 'select2-clear-all' and have the data attributes:
//    select-id: The ID of the select2 field

$(document).on('ready page:load', function() {
  $('.select2-select-all').click( function() {
    selectAll("#" + $(this).data("select-id"), $(this).data("select-all-path"));
    return false;
  });

  $('.select2-clear-all').click( function() {
    clearAll("#" + $(this).data("select-id"));
    return false;
  });
});

function selectAll(selectField, ajaxPath) {
  $.get(ajaxPath, function(data) {
    $.each(data, function(index, item) {
      // Find the option if it already exists
      if ($(selectField).find("option[value='" + item.id + "']").length)
      {
        // If the list of selected items is an array, select it with the other options
        if ($.isArray($(selectField).val()))
          $(selectField).val($(selectField).val().concat(item.id));
        // If the list of the selected items is a single item, create an array with the old item and new item
        else if ($(selectField).val() != undefined && $(selectField).val() != null)
          $(selectField).val([$(selectField).val(), item.id]);
        // If the list of selected items is empty, create an array with the new item
        else
          $(selectField).val([item.id]);
      }
      // If the option doesn't exist, create it and start selected
      else
        $(selectField).append(new Option(item.text, item.id, false, true));
    });

    // Update the select
    $(selectField).trigger('change');
  });
}

function clearAll(selectField) {
  $(selectField).val(null).trigger('change');
}
