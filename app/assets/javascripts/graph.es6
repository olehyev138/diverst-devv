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
            case 'line':
                this.renderLineChart();
                break;
        }
    }

    renderBarChart() {
        var series = this.data.series;
        var svg = this.$element[0].children[0];
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models.multiBarChart()
                .barColor(d3.scale.category20().range())
                .duration(300)
                .rotateLabels(45)
                .groupSpacing(0.3)
                .x(function (d) { return d.label; }) // set the json keys for x & y values
                .y(function (d) { return d.value; })
                .showControls(false)
                .stacked(false);

            chart.xAxis.showMaxMin(false);

            chart.yAxis
                .tickFormat(d3.format('d'));

            chart.reduceXTicks(false)
                 .staggerLabels(true);

            d3.select(svg)
                .datum(series)
                .call(chart);

            nv.utils.windowResize(chart.update);

            chart.multibar.dispatch.on('elementClick', function(e) {
                if ('children' in e.data && e.data.children.length != 0)
                    d3.select(svg)
                    .datum([e.data.children])
                    .transition().duration(500)
                    .call(chart);
            });

            return chart;
        });

        // TODO: get this working properly
        d3.selectAll('.drillout_button').on('click', function(){
            d3.select(svg)
                .datum(series)
                .transition().duration(500)
                .call(chart);
        });
    }

    renderLineChart() {
        var svg = this.$element[0].children[0];
        var series = this.data.series;
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models.lineWithFocusChart()
                .useInteractiveGuideline(true)
                .x(function (d) { return d.label; }) // set the json keys for x & y values
                .y(function (d) { return d.value; });

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
