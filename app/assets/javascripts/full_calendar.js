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
        url: calendarDataUrl,
        color: BRANDING_COLOR,
        textColor: 'white'
      }
    ]
  }); //endof fullcalendar
}