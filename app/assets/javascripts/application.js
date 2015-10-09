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
//= require_tree .

$(document).on('page:change', function() {
  $(document).off('page:change');

  $('.nav__link').each(function(o) {
    $(this).click(function() {
      $('.nav__link').removeClass('nav__link--is-selected');
      $(this).addClass('nav__link--is-selected');
    });
  });

  $('.secondary-header__tab').each(function(o) {
    $(this).click(function() {
      $('.secondary-header__tab').removeClass('secondary-header__tab--is-selected');
      $(this).addClass('secondary-header__tab--is-selected');
    });
  });

  $('.segmented-control__item').each(function(o) {
    $(this).click(function() {
      $('.segmented-control__item').removeClass('segmented-control__item--is-selected');
      $(this).addClass('segmented-control__item--is-selected');
    });
  });

  $('.counter').on('click', function() {
    $(this).toggleClass('counter--active');
  });
});