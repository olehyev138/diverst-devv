var graphs = [];

$(document).on('ready page:load', function() {
    load_graphs();
    update_graph_scopes();
});

function load_graphs() {
    // Instantiate a Graph object for each graph on page

    // make sure graphs array is cleared, if not itl screw up
    graphs = [];

    $('.graph').each(function() {
        graphs.push(new Graph($(this)));
    });
}

function update_graph_scopes() {
    $(".group-selector.group-selector-graphs").on('saveGroups', function(e, selectedGroups) {
      let ids = $.map(selectedGroups, function(group, key) {
        return group.id;
      });

      for (let graph of graphs) {
        graph.scoped_by_models = ids;
        graph.updateData(graph.rangeSelector.date_range);
      }

      let groupTexts = $.map(selectedGroups, function(group, key) {
        return "<span class='group-selected-text'>" + group.text + "</span>";
      });

      if (selectedGroups.length > 0)
        $(".groups-list").html(groupTexts.join(" "));
      else
        $(".groups-list").html("<h4>No filter</h4>");
    });
}
