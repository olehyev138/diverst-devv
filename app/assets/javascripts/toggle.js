$(document).on('ready page:load', function() {
  $('.ajax-toggle').bind('change', function() {
    var url = $(this).data('url');
    var enable_notification = $(this).is(':checked');
    $.ajax({
      url: url,
      type: 'PATCH',
      data: { 'enable_notification': enable_notification }
    });
  });
});
