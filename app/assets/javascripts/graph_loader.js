/* global $ */

$(document).on('ready page:load', function() {
    var graphs = [];

    $('.graph').each(function() {
        // search upwards for a graph input, pass to graph instance
        var $graph_input = $(this).siblings('.graph-input');
        var graph = new Graph($(this).data('url'), $(this), $graph_input);

        graphs.push(graph);
    });
});
