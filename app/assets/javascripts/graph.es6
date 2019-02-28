/* global $ */

const DEFAULT_MAX = 10;

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
            case 'custom':
                this.renderCustomChart();
                break;
            case 'line':
                this.renderLineChart();
                break;
        }
    }

    renderBarChart() {
        var data = this.data;
        var series = data.series;
        var graph_id = $(this.$element).attr('id');
        var select_string = '#' + graph_id  + ' svg';

        var $drillout_button = $(this.$element).siblings('.drillout_button');

        var svg = this.$element[0].children[0];
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models.multiBarChart()
                .barColor(d3.scale.category20().range())
                .duration(160)
                .rotateLabels(45)
                .groupSpacing(0.3)
                .x(function (d) { return d.x; }) // set the json keys for x & y values
                .y(function (d) { return d.y; })
                .showControls(false)
                .stacked(false);

            chart.xAxis
                .showMaxMin(false)
                .axisLabel(data.x_axis)
                .axisLabelDistance(10);

            chart.yAxis
                .tickFormat(d3.format('d'))
                .axisLabel(data.y_axis)
                .axisLabelDistance(10);

            chart.reduceXTicks(false)
                 .staggerLabels(true);

            d3.select(select_string)
                .datum(series)
                .call(chart);

            nv.utils.windowResize(chart.update);

            chart.multibar.dispatch.on('elementClick', function(e) {
                if ('children' in e.data && e.data.children.length != 0) {
                    d3.select(select_string)
                    .datum([e.data.children])
                    .transition().duration(500)
                    .call(chart);

                    $($drillout_button).toggle();
                }
            });

            return chart;
        });

        $($drillout_button).click(function(){
            d3.select(select_string)
                .datum(series)
                .transition().duration(500)
                .call(chart);

            $($drillout_button).toggle();
        });
    }

    renderCustomChart() {
        var data = this.data;
        var series = data.series;
        var graph_id = $(this.$element).attr('id');
        var select_string = '#' + graph_id  + ' svg';

        var $drillout_button = $(this.$element).siblings('.drillout_button');

        var svg = this.$element[0].children[0];
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models.multiBarChart()
                .barColor(d3.scale.category20().range())
                .duration(160)
                .rotateLabels(45)
                .groupSpacing(0.3)
                .x(function (d) { return d.x; }) // set the json keys for x & y values
                .y(function (d) { return d.y; })
                .showControls(true)
                .stacked(true);

            chart.xAxis
                .showMaxMin(false)
                .axisLabel(data.x_axis)
                .axisLabelDistance(10);

            chart.yAxis
                .tickFormat(d3.format('d'))
                .axisLabel(data.y_axis)
                .axisLabelDistance(10);

            chart.reduceXTicks(false)
                 .staggerLabels(true);

            d3.select(select_string)
                .datum(series)
                .call(chart);

            nv.utils.windowResize(chart.update);

            chart.multibar.dispatch.on('elementClick', function(e) {
                if ('children' in e.data && e.data.children.length != 0) {
                    d3.select(select_string)
                    .datum([e.data.children])
                    .transition().duration(500)
                    .call(chart);

                    $($drillout_button).toggle();
                }
            });

            return chart;
        });

        $($drillout_button).click(function(){
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
