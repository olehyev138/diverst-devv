$(document).on('ready page:load', function() {
  $('.data-table').each(function() {
    if(!$(this).data('default')) {
      $(this).dataTable(Utility.mergeWithDTDefaults({
        serverSide: true,
        ajax: $(this).data('source'),
        columnDefs: [
          { bSortable: false, targets: [2] }
        ]
      }));
    }
    else {
      $(this).dataTable(Utility.defaultDatatablesOptions);
    }
  });
});
