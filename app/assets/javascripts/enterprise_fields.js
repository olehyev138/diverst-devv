$(document).on('ready page:load', function()
{
  // Custom rules
  $('.boolean.private_toggle').change( function()
  {
    if ($(this).is(':checked'))
    {
      updateNextToggle(this, 'show_on_vcard_toggle', false);
      updateNextToggle(this, 'required_toggle', false);
    }
  });

  $('.boolean.show_on_vcard_toggle').change( function()
  {
    if ($(this).is(':checked'))
    {
      updateNextToggle(this, 'private_toggle', false);
    }
  });

  $('.boolean.required_toggle').change( function()
  {
    if ($(this).is(':checked'))
    {
      updateNextToggle(this, 'private_toggle', false);
      updateNextToggle(this, 'show_on_vcard_toggle', true);
    }
  });
});

function updateNextToggle(item, toggleClassName, check)
{
  // Must be changed if structure is changed drastically
  var toggle = $(item).closest('.field.boolean').parent().children('.field.boolean').find('.' + toggleClassName).first();

  if (check)
    $(toggle).prop('checked', true);
  else
    $(toggle).removeAttr('checked');
}
