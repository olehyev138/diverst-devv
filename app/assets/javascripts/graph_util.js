var graphs = [];

$(document).on('ready page:load', function() {
    load_graphs();
    update_graph_scopes();
});

function load_graphs() {
    // Instantiate a Graph object for each graph on page

    $('.graph').each(function() {
        graphs.push(new Graph($(this)));
    });
}

function update_graph_scopes() {
    $('.model-scoper').click(function() {
        var scoped_by_models = $('#select2-field-groups').val();

        for (const graph of graphs) {
            graph.scoped_by_models = scoped_by_models;
            graph.updateData(graph.rangeSelector.date_range);
        }

    });
}
