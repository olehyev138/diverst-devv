$(document).on('ready page:load', function() {
  ['.poll_initiative_box', '.poll_group_segment_box'].forEach(function(classType) {
    changeVisibility(classType);
    listenPollChanges(classType);
  });

  function changeVisibility(classType) {
    var hiddenClassType = getHiddenClassType(classType);
    var allBlank = true;

    $(classType).find('select').each(function() {
      if(allBlank && $(this).val() != null && $(this).val() !== ''){
        allBlank = false
      }
    });

    if(allBlank) {
       $(hiddenClassType).show();
    }
    else {
      $(hiddenClassType).find('select').each(function() {
        $(this).val('');
      });
      $(hiddenClassType).hide();
    }
  }

  function getHiddenClassType(classType) {
    return (classType === '.poll_initiative_box') ? '.poll_group_segment_box' : '.poll_initiative_box';
  }

  function listenPollChanges(classType) {
    $(classType).find('select').each(function() {
      $(this).change(function() {
        changeVisibility(classType)
      });
    });
  }
});
