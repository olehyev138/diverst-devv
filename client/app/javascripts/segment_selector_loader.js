$(document).on('ready page:load', function() {
    $('.segment-selector').each(function() {
        new SegmentSelector($(this));
    });
});