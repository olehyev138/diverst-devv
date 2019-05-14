/* global $ */

const MAX_LABEL_LENGTH = 12;
const BAR_GROUP_SPACING = 0.3;
const CHART_PADDING = 36;
const AXIS_PADDING = 15;
const HEIGHT_PER_ITEM = 50;
const HEIGHT_PER_GROUPED_ITEM = 35;
const LEGEND_MARGIN = { "top": 5, "left": 0, "right": 0, "bottom": 25 };
const LINE_GRAPH_CONTENT_HEIGHT = 250;

class Graph {
    constructor($element) {
        this.$element = $element;
        this.dataUrl = this.$element.data('url');
        this.data = {};

        this.brandingColor = BRANDING_COLOR || '#7B77C9';
        this.chartsColor = CHARTS_COLOR || this.brandingColor;
        this.colors = d3.scale.category20().range();
        this.colors[0] = this.chartsColor;

        this.scoped_by_models = [];

        var self = this;

        // Set up range selector
        var $graph_date_range = $(this.$element).siblings('.graph-date-range');
        if ($($graph_date_range).length && ($graph_date_range.attr('id') == 'range-selector')) {
            // if theres a range selector, instantiate it and set callback
            self.rangeSelector = new RangeSelector($graph_date_range[0], function (date_range) {
                self.updateData(date_range);
            });
        }

        // Setup csv export link
        var $csv_link = $(this.$element).siblings('.card__action').children('.csv-export-link');
        if ($($csv_link).length)
            $($csv_link).on('click', { self: self, csv_link: $csv_link }, this.csvExportLinkHandler);

        this.updateData();
    }

    csvExportLinkHandler(e) {
        var self = e.data.self;
        var $csv_link = e.data.csv_link;
        var url = $csv_link.data('url');

        var unset_series = [];

        $(self.$element).find('.nv-legendWrap .nv-series').each(function() {
            var selected_series_bool = $(this).find('circle').css('fill-opacity');

            // have to do this to find series names that might be cut off
            var series_name = $(this).find('title:first').text();
            if (series_name === "")
                series_name = $(this).find('text').text();

            if (selected_series_bool == 0)
                unset_series.push(series_name);
        });

        var date_range = {};
        if (self.rangeSelector) {
          date_range = self.rangeSelector.date_range;
        } else if (self.date_range) {
          date_range = self.date_range;
        }

        $.get(url, { date_range: date_range, unset_series: unset_series, scoped_by_models: self.scoped_by_models }, function(data) {
          Utility.displayFlash(data);
        }, "JSON");
    }

    updateData(date_range={}) {
        $.get(this.dataUrl,
              { date_range: date_range, scoped_by_models: this.scoped_by_models },
              (data) => {
                  // If the data is invalid, don't try to render the graph
                  if ($.isEmptyObject(data) || !data.hasOwnProperty("series")
                                            || !data.hasOwnProperty("title"))
                      return;

            this.onDataUpdate(data);
        }, 'json');
    }

    onDataUpdate(data) {
        this.data = data;
        this.attachToElement();
    }

    attachToElement() {
        switch (this.data.type) {
            case 'bar':
                this.stacked = false;
                this.showControls = false;
                this.renderBarChart();
                break;
            case 'custom':
                this.stacked = true;
                this.showControls = true;
                this.renderBarChart();
                break;
            case 'pie':
              this.renderPieChart();
              break;
            case 'line':
                this.renderLineChart();
                break;
        }
    }

    renderBarChart() {
        var graphObject = this;
        var stacked = this.stacked;
        var showControls = this.showControls;

        var data = this.data;
        var series = data.series;
        var select_string = buildSelectString(this);

        var $drillout_button = $(this.$element).siblings('.drillout_button');
        $drillout_button.hide();

        var svg = this.$element[0].children[0];
        var chart = null;

        var items = getUniqueXValuesFromSeriesArr(series).length;
        var aggs = getUniqueKeyValuesFromSeriesArr(series).length;

        nv.addGraph(function() {
            chart = nv.models.multiBarHorizontalChart()
                .margin({"left": 84, "right": 20})
                .color(graphObject.colors)
                .duration(160)
                .groupSpacing(BAR_GROUP_SPACING)
                .x(function (d) { return d.x; }) // set the json keys for x & y values
                .y(function (d) { return d.y; })
                .showControls(showControls)
                .stacked(stacked);

            chart.legend.margin(LEGEND_MARGIN);

            chart.xAxis
                .tickFormat(function(d) {
                  if (d.length > MAX_LABEL_LENGTH)
                    return d.substring(0, MAX_LABEL_LENGTH - 3) + "...";
                  return d;
                })
                .showMaxMin(false);

            chart.tooltip.headerFormatter(function(d) { return d; });
            chart.tooltip.hideDelay(0);

            chart.yAxis.tickFormat(d3.format('d'));

            d3.select(select_string)
                .datum(series)
                .call(chart);

            nv.utils.windowResize(function() {
              setBarChartHeight(chart, select_string, items, aggs);

              if (items && items > 0)
                moveBottomAxisToTop(select_string);
            });

            chart.multibar.dispatch.on('elementClick', function(e) {
                if (!$.isEmptyObject(e.data.children) && e.data.children.length != 0) {
                    items = getUniqueXValuesFromSeries(e.data.children).length;

                    d3.select(select_string)
                      .datum([e.data.children])
                      .transition().duration(500)
                      .call(chart);

                    setBarChartHeight(chart, select_string, items, aggs);

                    if (items && items > 0)
                      moveBottomAxisToTop(select_string);

                    $($drillout_button).toggle();
                }
            });

            chart.legend.dispatch.on('legendClick', function(item, index) {
              graphObject.legendClicked = true;
            });

            chart.legend.dispatch.on('legendDblclick', function(item, index) {
              graphObject.legendClicked = true;
            });

            chart.dispatch.on('stateChange', function(newState) {
              if (graphObject.legendClicked !== true || graphObject.stacked !== true)
                graphObject.stacked = newState.stacked;

              graphObject.renderBarChart();
              graphObject.legendClicked = false;
            });

            return chart;
        },
        // After chart generated callback
        function(chart) {
          setBarChartHeight(chart, select_string, items, aggs);

          if (items && items > 0)
            moveBottomAxisToTop(select_string);
        });

        $($drillout_button).off("click").click(function(){
            // Get new item count to calculate height
            items = getUniqueXValuesFromSeriesArr(series).length;

            d3.select(select_string)
                .datum(series)
                .transition().duration(500)
                .call(chart);

            setBarChartHeight(chart, select_string, items, aggs);

            if (items && items > 0)
              moveBottomAxisToTop(select_string);

            $($drillout_button).toggle();
        });
    }

    renderPieChart() {
        var graphObject = this;

        var svg = this.$element[0].children[0];
        var series = this.data.series[0]['values'];
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models.pieChart()
                .color(graphObject.colors)
                .margin({"right": 50})
                .x(function (d) { return d.x; }) // set the json keys for x & y values
                .y(function (d) { return d.y; })
                .labelsOutside(true)
                .labelThreshold(.07)
                .showLabels(true);

            chart.tooltip.hideDelay(0);

            d3.select(svg)
                .datum(series)
                .transition().duration(500)
                .call(chart);

            nv.utils.windowResize(chart.update);

            return chart;
        });
    }

    renderLineChart() {
        var graphObject = this;

        var svg = this.$element[0].children[0];
        var series = this.data.series;
        var select_string = buildSelectString(this);
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models.lineWithFocusChart()
                .color(graphObject.colors)
                .margin({"right": 50})
                .useInteractiveGuideline(true)
                .x(function (d) { return d.x; }) // set the json keys for x & y values
                .y(function (d) { return d.y; });

            chart.xAxis.tickFormat(function(d) {
                return d3.time.format('%x')(new Date(d));
            });

            chart.x2Axis.tickFormat(function(d) {
                return d3.time.format('%x')(new Date(d));
            });

            chart.tooltip.hideDelay(0);

            chart.yAxis
                .tickFormat(d3.format('d'));

            d3.select(svg)
                .datum(series)
                .transition().duration(500)
                .call(chart);

            nv.utils.windowResize(chart.update);

            chart.focus.dispatch.on("brush", function(extent) {
                graphObject.date_range = { from_date: moment(extent.extent[0]).format(), to_date: moment(extent.extent[1]).format() };
            });

            return chart;
        },
        // After chart generated callback
        function(chart) {
          setLineChartHeight(chart, select_string);
        });
    }
}

// *************** General Helpers ***************

// Builds the string to use as a selector from the chart object
function buildSelectString(chart) {
  return '#' + $(chart.$element).attr('id') + ' svg';
}

// Gets the `transform: translate` Y value for a selector
function getTransformTranslateY(elementSelector) {
  return parseInt(d3.select(elementSelector).attr('transform').split(',')[1]);
}

// Gets the unique X values from a series object
function getUniqueXValuesFromSeries(series, prev = []) {
  $.each(series.values, function(valuesIndex, valuesItem) {
    if (!prev.includes(valuesItem.x))
      prev.push(valuesItem.x);
  });

  return prev;
}

// Gets the unique X values from an array of series
function getUniqueXValuesFromSeriesArr(seriesArr, prev = []) {
  $.each(seriesArr, function(seriesIndex, seriesItem) {
    getUniqueXValuesFromSeries(seriesItem, prev);
  });

  return prev;
}

// Gets the unique key values from an array of series
function getUniqueKeyValuesFromSeriesArr(seriesArr, prev = []) {
  $.each(seriesArr, function(seriesIndex, seriesItem) {
    if (!prev.includes(seriesItem.key))
      prev.push(seriesItem.key);
  });

  return prev;
}

// *************** Bar Chart Helpers ***************

// Moves the bottom axis to the top so that the user can see the ticks without scrolling down
function moveBottomAxisToTop(selectString) {
  d3.selectAll(selectString + " .nv-y > .nv-axis > g text," + selectString + " .nv-y > .nv-axis > g path," + selectString + " .nv-y > .nv-axis > .nv-axisMaxMin .nv-axisMaxMin")
    .attr("transform", "translate(0,-" + ( getTransformTranslateY(selectString + " .nv-y") + AXIS_PADDING ) + ")");
}

// Modifies bar chart height to be dynamic based on the number of items
function setBarChartHeight(chart, selectString, itemCount, aggCount) {
  var height = calcBarChartHeight(itemCount, aggCount, chart.legend.height(), chart.stacked());

  chart.height(height);
  $(selectString).css("height", height);

  chart.update();
}

// Calculates the height of a bar chart based on data size and chart options
function calcBarChartHeight(itemCount, aggCount, legendHeight, stacked) {
  var h;

  if (stacked)
    h = HEIGHT_PER_ITEM * itemCount;
  else
    h = HEIGHT_PER_GROUPED_ITEM * itemCount * aggCount;

  h += legendHeight + LEGEND_MARGIN.bottom + LEGEND_MARGIN.top;
  
  if (h < 350)
     h = 350;

  return h;
}

// *************** Line Chart Helpers ***************

// Modifies line chart height based on legend/focus height
function setLineChartHeight(chart, selectString) {
  var height = calcLineChartHeight(chart.legend.height(), chart.focus.height());

  chart.height(height);
  $(selectString).css("height", height);

  chart.update();
}

// Calculates the height of a line chart based on legend size
function calcLineChartHeight(legendHeight, focusHeight) {
  var h = LINE_GRAPH_CONTENT_HEIGHT + legendHeight + focusHeight;

  if (h < 350)
    h = 350;

  return h;
}
