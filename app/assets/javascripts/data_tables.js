$(document).on('ready page:load', function() {
  $('.data-table').each(function() {
    if(!$(this).data('default')) {
      $(this).dataTable(Utility.mergeWithDTDefaults({
        serverSide: true,
        ajax: $(this).data('source'),
        columnDefs: [
          { bSortable: false, targets: [$(this).data('no-sortable')] }
        ]
      }));
    }
    else {
      $(this).dataTable(Utility.defaultDatatablesOptions);
    }
  });
});
