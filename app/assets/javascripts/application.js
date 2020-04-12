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
//= require bootstrap/dist/js/bootstrap.min
//= require jquery_ujs
//= require jquery-ui
//= require jquery-ui/widget
//= require dataTables/jquery.dataTables
//= require turbolinks
//= require cocoon
//= require select2/dist/js/select2.min
//= require rangeslider.js/dist/rangeslider
//= require sortablejs/Sortable.min
//= require moment/min/moment.min
//= require pikaday-time
//= require pikaday-time/plugins/pikaday.jquery
//= require fullcalendar/dist/fullcalendar.min
//= require tooltipster
//= require urijs/src/URI.min
//= require jscolor/jscolor
//= require flip
//= require @claviska/jquery-dropdown/jquery.dropdown.min
//= require hamburger_menu
//= require jquery-embedly
//= require ckeditor/init
//= require codemirror/lib/codemirror
//= require firepad/dist/firepad.min
//= require firebase/firebase
//= require bootstrap-timepicker/js/bootstrap-timepicker.min
//= require d3/d3.min
//= require nvd3/build/nv.d3.min
//= require_tree .

var Utility = (function() {

  var flashTimeout;

  // Autohides alert after a certain amount of time
  var autoHideAlerts = function() {
    $('p.notice, p.alert, p.reward').fadeOut(300, function() { $(this).remove() });
  };

  // Accepts a message object in the form of { "<alertType>":"<message>" }
  var displayFlash = function(messageObj) {
    clearTimeout(flashTimeout);
    clearTimeout(initialTimeout);

    var type = Object.keys(messageObj)[0];

    $('.flash_container').html(`
        <p class="${type}">${messageObj[type]}</p>
    `);
    $('p.' + type).hide();
    $('p.' + type).fadeIn(300);

    flashTimeout = setTimeout(function() {
      Utility.autoHideAlerts();
    }, 4500);
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
    displayFlash: displayFlash,
    submitOnReturn: submitOnReturn,
    mergeWithDTDefaults: mergeWithDTDefaults,
    defaultDatatablesOptions: defaultDatatablesOptions
  };

})();

var initialTimeout = setTimeout(function() {
  Utility.autoHideAlerts();
}, 4500);
