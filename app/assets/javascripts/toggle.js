$(document).on('ready page:load', function() {
  var notifications_frequency = $(".ajax-toggle-1").val();
  if(notifications_frequency === "weekly"){
    $('.notifications_date').show();
  }else{
    $('.notifications_date').hide();
  }

  $('#user_group').bind('change', function() {
    var url = $(".ajax-toggle-1").data('url');
    var notifications_frequency = $(".ajax-toggle-1").val();
    var notifications_date = $(".ajax-toggle-2").val();
    if(notifications_frequency === "weekly"){
      $('.notifications_date').show();
    }else{
      $('.notifications_date').hide();
    }
    $.ajax({
      url: url,
      type: 'PATCH',
      data: { 'user_group': { 'notifications_frequency': notifications_frequency, 'notifications_date': notifications_date } }
    });
  });
});
