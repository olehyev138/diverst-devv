$(document).ready(function(){
  $('#enterprise_theme_primary_color').change(function(){
    var $useSecondaryColor = $('#enterprise_theme_use_secondary_color');
    var $secondaryColorInput = $('#enterprise_theme_secondary_color');

    // If user prefer to not use separate color for charts,
    // Set charts color to be equal to primary color
    if( !$useSecondaryColor.is(':checked')) {
      $secondaryColorInput.val( $(this).val() );
      document.getElementById('enterprise_theme_secondary_color')
        .jscolor.fromString( $(this).val())
    }
  });
});