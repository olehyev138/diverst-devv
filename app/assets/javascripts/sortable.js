$(document).on('ready page:load', function() {
  Sortable.create(document.getElementById('fields'), {
    onSort: function() {
      $("#fields .nested-fields").each(function(i) {
        $(this).find("input").each(function() {
          $(this).attr(
            "name",
            this.name.replace(/\[fields_attributes\]\[\d+\]/, "[fields_attributes]["+i+"]")
          );
        });
      });
    }
  });
});
