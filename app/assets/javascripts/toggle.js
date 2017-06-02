$(document).on('ready page:load', function() {
  $('.ajax-toggle').bind('change', function() {
    var url = $(this).data('url');
    var frequency_notification = $(this).val();
    $.ajax({
      url: url,
      type: 'PATCH',
      data: { 'user_group': { 'frequency_notification': frequency_notification } }
    });
  });
});
