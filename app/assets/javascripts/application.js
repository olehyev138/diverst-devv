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
//= require bootstrap
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require turbolinks
//= require cocoon
//= require select2
//= require highcharts
//= require highcharts/highcharts-more
//= require highcharts/modules/data
//= require highcharts/modules/drilldown
//= require sparklines
//= require rangeslider.js/dist/rangeslider
//= require Sortable
//= require moment
//= require pikaday-time
//= require pikaday-time/plugins/pikaday.jquery
//= require fullcalendar
//= require tooltipster
//= require urijs
//= require jscolor/jscolor
//= require flip
//= require jquery-dropdown/jquery.dropdown.min
//= require hamburger_menu
//= require embedly-jquery
//= require ckeditor/init
//= require twilio-video
//= require codemirror/lib/codemirror
//= require firepad/dist/firepad.min
//= require firebase/firebase
//= require bootstrap-timepicker
//= require_tree .

var Utility = (function() {

  // Autohides alert after a certain amount of time
  var autoHideAlerts = function() {
    $('p.notice, p.alert, p.reward').fadeOut(300, function() { $(this).remove(); });
  };

  // Submits the passed input's form when pressing return while the input is focused
  var submitOnReturn = function($el) {
    $el.keydown(function(e) {
      if (e.keyCode === 13 && !e.shiftKey) {
        $(this.form).submit();
        return false;
      }
    });
  };

  var defaultDatatablesOptions = {
    pagingType: "full_numbers",
    dom: "frtpl",
    language: {
    search: "",
      searchPlaceholder: "Search..."
    }
  };

  var mergeWithDTDefaults = function(params) {
    return $.extend(true, {}, defaultDatatablesOptions, params);
  };

  return {
    autoHideAlerts: autoHideAlerts,
    submitOnReturn: submitOnReturn,
    mergeWithDTDefaults: mergeWithDTDefaults,
    defaultDatatablesOptions: defaultDatatablesOptions
  };

})();

setTimeout(function() {
  Utility.autoHideAlerts();
}, 4500);
