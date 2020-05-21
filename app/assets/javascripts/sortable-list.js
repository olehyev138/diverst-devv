// sortable-list differs from sortable in that it uses a position column on the item

$(document).on('ready page:load', function() {
  element = document.getElementById('sortable-list');
  if(element) {
    Sortable.create(element, {
      onSort: function() {
        // Get an index for every sortable item and set the position field accordingly
        $("#sortable-list .nested-fields").each(function(i) {
          $(this).find(".position-field").each(function() {
            $(this).val(i);
          });
        });
      },
      onStart: function() {
        $("#sortable-list .nested-fields").each(function() {
          $(this).find(":input, label, span").each(function() {
            if(!$(this).hasClass("sortable-focus")){
              $(this).hide();
            }
          });
        });
      },
      onEnd: function() {
        $("#sortable-list .nested-fields").each(function() {
          $(this).find(":input, label, span").each(function() {
            $(this).show();
          });
        });
      }
    });
  }
});
