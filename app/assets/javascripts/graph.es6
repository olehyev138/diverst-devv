/* global $ */

const MAX_LABEL_LENGTH = 13;
const BAR_GROUP_SPACING = 0.3;
const CHART_PADDING = 36;
const AXIS_PADDING = 8;
const HEIGHT_PER_ITEM = 50;

class Graph {
    constructor(dataUrl, $element, $graph_input) {
        this.dataUrl = dataUrl;
        this.$element = $element;
        this.data = {};

        this.brandingColor = BRANDING_COLOR || $('.primary-header').css('background-color') || '#7B77C9';
        this.chartsColor = CHARTS_COLOR || this.brandingColor;

        var self = this;
        if ($($graph_input).length && ($graph_input.attr('id') == 'range-selector')) {
            // if theres a range selector, instantiate it and set callback
            var rangeSelector = new RangeSelector($graph_input[0], function (input) {
                self.updateData(input);
            });
        }

        this.updateData();
    }

    updateData(input={}) {
        $.get(this.dataUrl, { input: input }, (data) => {
            this.onDataUpdate(data);
        });
    }

    onDataUpdate(data) {
        this.data = data;
        this.attachToElement();
    }

    attachToElement() {
        switch (this.data.type) {
            case 'bar':
                this.renderBarChart();
                break;
            case 'line':
                this.renderLineChart();
                break;
        }
    }

    renderBarChart() {
        var data = this.data;
        var series = data.series;
        var select_string = buildSelectString(this);

        var $drillout_button = $(this.$element).siblings('.drillout_button');

        var svg = this.$element[0].children[0];
        var chart = null;

        var items = getUniqueXValuesFromSeriesArr(series).length;

        nv.addGraph(function() {
            chart = nv.models.multiBarHorizontalChart()
                .height(HEIGHT_PER_ITEM * items)
                .margin({"left": 80, "right": 20})
                .barColor(d3.scale.category20().range())
                .duration(160)
                .groupSpacing(BAR_GROUP_SPACING)
                .x(function (d) { return d.x; }) // set the json keys for x & y values
                .y(function (d) { return d.y; })
                .showControls(false)
                .stacked(false);

            chart.legend.margin({"bottom": 20});

            chart.xAxis
                .tickFormat(function(d) {
                  if (d.length > MAX_LABEL_LENGTH)
                    return d.substring(0, MAX_LABEL_LENGTH - 3) + "...";
                  return d;
                })
                .showMaxMin(false)
                .axisLabel(data.x_axis)
                .axisLabelDistance(10);

            chart.tooltip.headerFormatter(function(d) { return d; });

            chart.yAxis
                .tickFormat(d3.format('d'))
                .axisLabel(data.y_axis)
                .axisLabelDistance(10);

            d3.select(select_string)
                .datum(series)
                .call(chart);

            nv.utils.windowResize(chart.update);

            chart.multibar.dispatch.on('elementClick', function(e) {
                if ('children' in e.data && e.data.children.length != 0) {
                    items = getUniqueXValuesFromSeries(e.data.children).length;

                    d3.select(select_string)
                      .datum([e.data.children])
                      .transition().duration(500)
                      .call(chart);

                    $($drillout_button).toggle();
                }
            });

            return chart;
        },
        // After chart generated callback
        function(chart) {
          // Resize the chart accordingly
          setChartHeight(chart, select_string, items);

          if (items && items > 0) {
            // Moves the bottom axis to the top so that the user can see the ticks without scrolling down
            d3.selectAll(select_string + " .nv-y > .nv-axis > g text," + select_string + " .nv-y > .nv-axis > g path," + select_string + " .nv-y > .nv-axis > .nv-axisMaxMin .nv-axisMaxMin")
              .attr("transform", "translate(0,-" + ( getTransformTranslateY(select_string + " .nv-y") + AXIS_PADDING ) + ")");
          }
        });

        $($drillout_button).click(function(){
            // Get new item count to calculate height
            items = getUniqueXValuesFromSeriesArr(series).length;

            d3.select(select_string)
                .datum(series)
                .transition().duration(500)
                .call(chart);

            $($drillout_button).toggle();
        });
    }

    renderLineChart() {
        var svg = this.$element[0].children[0];
        var series = this.data.series;
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models.lineWithFocusChart()
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

            chart.yAxis
                .tickFormat(d3.format('d'));

            d3.select(svg)
                .datum(series)
                .transition().duration(500)
                .call(chart);

            nv.utils.windowResize(chart.update);

            return chart;
        });
    }
}

// Builds the string to use as a selector from the chart object
function buildSelectString(chart) {
  return '#' + $(chart.$element).attr('id') + ' svg';
}

// Modifies chart height to be dynamic based on the number of items
function setChartHeight(chart, selectString, itemCount) {
  var height = HEIGHT_PER_ITEM * itemCount;
  if (height < 350)
    height = 350;

  chart.height(height);
  $(selectString).css("height", height);
  chart.update();
}

// Gets the `transform: translate` Y value for a selector
function getTransformTranslateY(elementSelector) {
  return parseInt(d3.select(elementSelector).attr('transform').split(',')[1]);
}

// Gets the unique X values from a series object
function getUniqueXValuesFromSeries(series, prev) {
  $.each(series.values, function(valuesIndex, valuesItem) {
    if (!prev.includes(valuesItem.x))
      prev.push(valuesItem.x);
  });
}

// Gets the unique X values from an array of series
function getUniqueXValuesFromSeriesArr(seriesArr) {
  var prev = [];
  $.each(seriesArr, function(seriesIndex, seriesItem) {
    getUniqueXValuesFromSeries(seriesItem, prev);
  });

  return prev;
}
