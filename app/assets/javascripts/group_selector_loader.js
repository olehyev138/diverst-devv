$(document).on('ready page:load', function() {
    $('.group-selector').each(function() {
        new GroupSelector($(this));
    });
});