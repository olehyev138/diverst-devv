$(document).on('ready page:load', function() {
    var graphs = [];

    $('.graph').each(function() {
        // search for a graph_input and pass to Graph
        var $graph_input = $(this).siblings('.graph-input');
        var graph = new Graph($(this).data('url'), $(this), $graph_input);

        graphs.push(graph);
    });
});
