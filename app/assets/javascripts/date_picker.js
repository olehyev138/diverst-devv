$(document).on('ready page:load', function(){
  $('.date_picker_input').each(function(i, field){
    initializeDatePicker(field, 'YYYY-MM-DD', false);
  });

  $('.content__main').on('cocoon:after-insert', function(e, insertedItem) {
    var dateField = $(insertedItem).find('input.date_picker_input');

    initializeDatePicker(dateField[0], 'YYYY-MM-DD', false);
  });

  $('.date_time_picker_input').each(function(i, field){
    initializeDatePicker(field, 'YYYY-MM-DD HH:mm', true);
  });

  function initializeDatePicker(field, format, showTime) {
    var picker = new Pikaday({
      field: field,
      showTime: showTime,
      format: format,
      autoClose: false,
      incrementMinuteBy: 15,
      use24hour: true,
      yearRange: [new Date().getFullYear(), new Date().getFullYear() + 2],
      onOpen: function() {
        if($(field).val() == '') {
          var hour = new Date().getHours();
          var minute = Math.ceil(new Date().getMinutes()/15)*15;
          var roundedHour = minute > 45 ? hour + 1 : hour;
          var roundedMinute = minute > 45 ? 0 : minute;

          $('.pika-select-hour').val(roundedHour);
          $('.pika-select-minute').val(roundedMinute);
        }
      }
    });
  };
});
