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
       if (this.data.type == 'nvd3')  // DEBUG - tmp so we only run our test action
            this.renderBarChart();
    }

    renderBarChart() {
        /* Todo:
         *   - add abstractions for most of this so we can reuse code
         */

        var series = [this.data];
        var svg = this.$element[0].children[0];
        var chart = null;

        nv.addGraph(function() {
            chart = nv.models
                .multiBarChart()
                .x(function (d) { return d.label; }) // set the json key for x value
                .y(function (d) { return d.value; }) // set the json key for y value
                .showControls(false)
                .stacked(false);

            chart.yAxis
                .axisLabel('Group member count')
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

        d3.select('#back').on('click', function(){
            d3.select(svg)
                .datum(series)
                .transition().duration(500)
                .call(chart);
        });
    }
}
