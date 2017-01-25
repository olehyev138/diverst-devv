$(document).ready(function(){
  element = document.getElementById('sortable');
  if(element) {
    Sortable.create(element, {
      onSort: function() {
        $("#sortable .nested-fields").each(function(i) {
          $(this).find("input").each(function() {
            $(this).attr(
              "name",
              this.name.replace(/\[fields_attributes\]\[\d+\]/, "[fields_attributes]["+i+"]")
            );
          });
        });
      }
    });
  }
});
