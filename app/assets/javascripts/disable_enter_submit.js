$(document).on('ready page:load', function() {
  $(".disable-enter-submit").on("keypress", function (e) {
    if (e.keyCode == 13) {
        return false;
    }
  });
});
