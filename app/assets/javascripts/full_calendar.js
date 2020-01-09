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

      eventMouseover: function(event, jsEvent, view) {
        var groupName = event.group_name;

        $(this).popover({
          html: true,
          title: groupName,
          placement: 'top',
          trigger: 'hover',
          content: event.description,
          container: '#calendar'
      }).popover('toggle');
      },


      buttonIcons: false,
      eventSources: [
        {
          url: calendarDataUrl
        }
      ]
    }); //endof fullcalendar
  }
});
