$(document).on('ready page:load', function() {
  $('.select2').select2();
});

$(document).on('ready page:load', function() {
  $('.multiple-input').each(function() {
    $(this).select2({
      tags: true,
      data: window.tags,
      tokenSeparators: [',', ' '],
      createTag: function(tag) {
        return {
          id: tag.term,
          text: tag.term,
          isNew: true,
          name: tag.term
        };
      }
    });
  });
});