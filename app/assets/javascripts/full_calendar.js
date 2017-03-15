$(document).on('ready page:load', function(){
  $('.calendar-filters').toggle();
  listenCalendarVisibility();
  applyFullCalendar();

  function listenCalendarVisibility() {
    $('.calendar-filters-visibility').on('click', function() {
      $('.select2').css('width', '100%');
      $('.calendar-filters').toggle();
      if($('.calendar-filters').is(':visible')) {
        $(this).text($(this).data('hide-text'));
      }
      else {
        $(this).text($(this).data('show-text'));
      }
    });
  }

  function applyFullCalendar(selector) {
    selector = selector || '#calendar';

    var $calendar = $(selector);
    var calendarDataUrl = $calendar.data('calendar-data-url');

    $calendar.fullCalendar({
      header: {
        left:   'title',
        center: 'month,agendaWeek',
        right:  'prev,today,next'
      },
      eventSources: [
        {
          url: calendarDataUrl
        }
      ]
    }); //endof fullcalendar
  }
});
