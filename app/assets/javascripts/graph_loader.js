$(document).on('ready page:load', function() {
  var graphs = [];

  $('.graph').each(function() {
    if($(this).data('time-series')) {
      data = {
        dataUrl: $(this).data('url'),
        element: $(this),
        title: $(this).data('title')
      };
      if($("#date_picker_from").val()) {
        data['from'] = moment($("#date_picker_from").val());
      }
      if($("#date_picker_to").val()) {
        data['to'] = moment($("#date_picker_to").val());
      }
      graphs.push(
        new TimeSeriesGraph(data)
      );
    }
    else if($(this).data('date-histogram')) {
      graphs.push(new DateHistogramGraph($(this).data('url'), $(this)));
    }
    else {
      graphs.push(new Graph($(this).data('url'), $(this)));
    }
  });

  $('.js-time-range-btn').click(function() {
    graphs.forEach(function(graph) {
      graph.from = moment($("#date_picker_from").val());
      graph.to = moment($("#date_picker_to").val());
      graph.updateData();
    });
  });
});
