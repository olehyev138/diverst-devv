$(document).on('ready page:load', function() {
  element = document.getElementById('sortable');
  if(element) {
    var $fields = $("#sortable .nested-fields");
    Sortable.create(element, {
      onSort: function() {
        $fields.each(function(i) {
          $(this).find("input").each(function() {
            $(this).attr(
              "name",
              this.name.replace(/\[fields_attributes\]\[\d+\]/, "[fields_attributes]["+i+"]")
            );
          });
        });
      },
      onStart: function() {
        $fields.each(function() {
          $(this).children().each(function() {
            if(!$(this).hasClass("poll_fields_title")){
              $(this).hide();
            }
          });
        });
      },
      onEnd: function() {
        $fields.each(function() {
          $(this).children().each(function() {
            $(this).show();
          });
        });
      }
    });
  }
});
