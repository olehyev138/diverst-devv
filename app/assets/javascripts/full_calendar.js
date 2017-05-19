$(document).on('ready page:load', function(){
  applyFullCalendar();

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
