$(document).ready(function(){
  $('.date_picker_input').each(function(i, field){
    initializeDatePicker(field);
  });

  $('.content__main').on('cocoon:after-insert', function(e, insertedItem) {
    var dateField = $(insertedItem).find('input.date_picker_input');

    initializeDatePicker(dateField[0]);
  });

  function initializeDatePicker(field) {
    var picker = new Pikaday({
      field: field,
      format: 'YYYY-MM-DD',
      yearRange: [new Date().getFullYear(), new Date().getFullYear() + 2]
    });

  };
});
