/* global $ */

const DEFAULT_MAX = 10;

class Graph {
    constructor(dataUrl, $element) {
        this.dataUrl = dataUrl;
        this.$element = $element;
        this.data = {};

        this.brandingColor = BRANDING_COLOR || $('.primary-header').css('background-color') || '#7B77C9';
        this.chartsColor = CHARTS_COLOR || this.brandingColor;

        this.updateData();
    }

    updateData() {
        $.get(this.dataUrl, (data) => {
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
        /* Todo:
         *   - add abstractions for most of this to remove complexity and so we can reuse code
         */

        var series = this.data.series;
        var svg = this.$element[0].children[0];
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models
                .multiBarChart()
                .x(function (d) { return d.label; }) // set the json keys for x & y values
                .y(function (d) { return d.value; })
                .showControls(false)
                .stacked(false);

            chart.yAxis
                .tickFormat(d3.format('d'));

            d3.select(svg)
                .datum(series)
                .transition().duration(500)
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
        /* Todo:
         *   - add abstractions for most of this to remove complexity and so we can reuse code
         */

        var series = this.data.series;
        var svg = this.$element[0].children[0];
        var chart = null;

        console.log('henlo');

        nv.addGraph(function() {
            chart = nv.models
                .lineChart()
                .x(function (d) { return d.label; }) // set the json keys for x & y values
                .y(function (d) { return d.value; });

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
