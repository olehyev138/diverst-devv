$(document).ready(function(){
  $('#enterprise_theme_primary_color').change(function(){
    var $useSecondaryColor = $('#enterprise_theme_use_secondary_color');
    var $secondaryColorInput = $('#enterprise_theme_secondary_color');

    if( !$useSecondaryColor.is(':checked')) {
      $secondaryColorInput.val( $(this).val() );
    }
  });
});