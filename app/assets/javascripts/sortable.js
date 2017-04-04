$(document).on('ready page:load', function() {
  element = document.getElementById('sortable');
  if(element) {
    Sortable.create(element, {
      onSort: function() {
        $("#sortable .nested-fields").each(function(i) {
          $(this).find(":input").each(function() {
            $(this).attr(
              "name",
              this.name.replace(/\[\d+\]/, "["+i+"]")
            );
          });
        });
      },
      onStart: function() {
        $("#sortable .nested-fields").each(function() {
          $(this).find(":input, label, span").each(function() {
            if(!$(this).hasClass("sortable-focus")){
              $(this).hide();
            }
          });
        });
      },
      onEnd: function() {
        $("#sortable .nested-fields").each(function() {
          $(this).find(":input, label, span").each(function() {
            $(this).show();
          });
        });
      }
    });
  }
});
