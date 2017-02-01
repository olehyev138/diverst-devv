$(document).on('ready page:load', function() {
  $('#group-members').dataTable(Utility.mergeWithDTDefaults({
    serverSide: true,
    ajax: $('#group-members').data('source')
  }));
});
