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
        var virtual_event = event.virtual
        var isVirtual = function() {
          if(virtual_event){ 
            return "virtual event\n";
          }
        };

        $(this).popover({
          html: true,
          title: groupName,
          placement: 'top',
          trigger: 'hover',
          content: `${isVirtual()}` + event.description,
          container: '#calendar'
      });
      },

      eventClick: function() {
        $('.popover').remove();
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
