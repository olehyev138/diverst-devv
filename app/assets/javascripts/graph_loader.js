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
      if($(this).data('spark')) {
        data['spark'] = true;
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

  $('.graph-field').each(function() {
    changeGraphTypeVisibility($(this));
  });

  $('.graph-field').on('change', function() {
    changeGraphTypeVisibility($(this));
  });

  function changeGraphTypeVisibility(element) {
    var timeseriesElem = $('.js-graph-type-timeseries');
    if($(element).find('option:selected').hasClass('numeric-field-true')) {
      var statsElem = $('.js-graph-type-stats');

      timeseriesElem.parent().find('.segmented-control__item--is-selected').removeClass('segmented-control__item--is-selected');
      timeseriesElem.hide();
      $('.js-date-range').hide();
      statsElem.addClass('segmented-control__item--is-selected');
      statsElem.parent().find('input').val(statsElem.first().data('value'));

      $('.graph-aggregation-field').hide();
    }
    else {
      timeseriesElem.show();

      $('.graph-aggregation-field').show();
    }
  }
});
