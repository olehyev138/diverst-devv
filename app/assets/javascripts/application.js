// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require cocoon
//= require select2
//= require highcharts
//= require rangeslider.js/dist/rangeslider
//= require jquery-sticky
//= require_tree .

var Utility = (function() {

  // Autohides alert after a certain amount of time
  var autoHideAlerts = function() {
    $('p.notice, p.alert').fadeOut(300, function() { $(this).remove(); });
  };

  return {
    autoHideAlerts: autoHideAlerts
  };

})();

setTimeout(function() {
  Utility.autoHideAlerts();
}, 4500);