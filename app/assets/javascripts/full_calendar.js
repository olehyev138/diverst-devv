$(document).on('ready page:load', function(){
  listenCalendarVisibility();
  applyFullCalendar();

  function listenCalendarVisibility() {
    var hidden = false;
    $('.calendar-filters-visibility').on('click', function() {
      hidden = $(this).text() === 'Show filters' ? false : true;
      if(hidden) {
        $(this).text('Show filters');
      }
      else {
        $(this).text('Hide filters');
      }
      $('.calendar-filters').toggle();
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
