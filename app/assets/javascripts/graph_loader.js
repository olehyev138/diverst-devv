/* global $ */

$(document).on('ready page:load', function() {
    var graphs = [];

    $('.graph').each(function() {
        graphs.push(new Graph($(this).data('url'), $(this)));
    });
});
