$(document).on('ready page:load', function() {
  $('.ajax-toggle').bind('change', function() {
    var url = $(this).data('url');
    var notifications_frequency = $(this).val();
    $.ajax({
      url: url,
      type: 'PATCH',
      data: { 'user_group': { 'notifications_frequency': notifications_frequency } }
    });
  });
});
