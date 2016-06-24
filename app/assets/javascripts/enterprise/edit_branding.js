$(document).ready(function(){
  var $primaryColorInput = $('#enterprise_theme_primary_color')
  var $secondaryColorInput = $('#enterprise_theme_secondary_color');
  var $useSecondaryColor = $('#enterprise_theme_use_secondary_color');

  $primaryColorInput.change(function(){
    // If user prefer to not use separate color for charts,
    // Set charts color to be equal to primary color
    if( !$useSecondaryColor.is(':checked')) {
      changeInputColor($secondaryColorInput, $(this).val() );
    }
  }); //endof .change

  $secondaryColorInput.change(function(){
    if( !$useSecondaryColor.is(':checked')) {
      changeInputColor($secondaryColorInput, $primaryColorInput.val() );
    }
  }); //endof change

  $useSecondaryColor.change(function(){
    if( !$(this).is(':checked') ) {
      changeInputColor($secondaryColorInput, $primaryColorInput.val() );
    }
  });



  function changeInputColor($input, colorString) {
    $input.val( colorString );
    document.getElementById( $input.attr('id') )
      .jscolor.fromString( colorString );
  }
});