const DEFAULT_MAX = 10

class Graph {
  constructor(dataUrl, $element) {
    this.dataUrl = dataUrl;
    this.$element = $element;
    this.data = {};

    this.brandingColor = BRANDING_COLOR || $('.primary-header').css('background-color') || '#7B77C9'
    this.chartsColor = CHARTS_COLOR || this.brandingColor

    this.updateData(this.dataUrl);
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
    if (this.data.type === "NumericField" || this.data.type === "DateField" || this.data.type === "bar")
      this.renderBarChart()
    else if (this.data.type === "CheckboxField" || this.data.type === "SelectField" || this.data.type === "GroupsField"  || this.data.type === "SegmentsField")
      if (this.data.hasAggregation)
        this.renderBarChart()
      else
        this.renderPieChart()
    else if (this.data.type === "pie")
      this.renderPieChart()
    else if (this.data.type == 'time_based')
      this.renderTimeBasedChart()
  }

  renderBarChart() {
    this.$element.highcharts({
      chart: {
        type: 'column',
        inverted: true,
        style: {
          fontFamily: 'Helvetica Neue, sans-serif'
        }
      },
      title: {
        text: ''
      },
      xAxis: {
        type: 'category',
        categories: this.data.highcharts.categories,
        min: 0,
        max: this.data.highcharts.limit || DEFAULT_MAX,
        scrollbar: { enabled: this.data.highcharts.scrollbar || true },
      },
      yAxis: {
        min: 0,
        title: {
          text: this.data.highcharts.yAxisTitle || 'Nb of users'
        },
        allowDecimals: false
      },
      plotOptions: {
        series: {
          stacking: 'normal',
          borderWidth: 0
        }
      },
      tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
          '<td style="padding:0"><b>{point.y}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
      },
      series: this.data.highcharts.series,
      credits: {
        enabled: false
      },
      colors: [this.chartsColor, '#F15E57', '#FE6D4B', '#9FD661', '#40D0AD', '#48C0EB', '#5A9AEF', '#EE85C1'],
      drilldown: {
        series: this.data.highcharts.drilldowns,
        activeAxisLabelStyle: {
          textDecoration: 'none'
        },
        activeDataLabelStyle: {
          color: 'white'
        }
      }
    });
  }

  renderPieChart() {
    this.$element.highcharts({
      chart: {
        type: 'pie',
        style: {
          fontFamily: 'Helvetica Neue, sans-serif'
        }
      },
      plotOptions: {
        pie: {
          dataLabels: {
            enabled: true,
            format: "{point.name}",
            style: {
              width:'70px',
              textOverflow: 'ellipsis',
              overflow: 'hidden'
            }
          }
        }
      },
      title: {
        text: ''
      },
      series: this.data.highcharts.series,
      tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="padding:0"><b>{point.y}</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
      },
      credits: {
        enabled: false
      },
      colors: [this.chartsColor, '#F15E57', '#FE6D4B', '#9FD661', '#40D0AD', '#48C0EB', '#5A9AEF', '#EE85C1']
    });
  }

  renderTimeBasedChart() {
    Highcharts.stockChart(this.$element[0], {
      title: {
          text: 'Growth of groups'
      },
      rangeSelector: {
          floating: true,
          y: -65,
          verticalAlign: 'bottom'
      },
      navigator: {
          margin: 60
      },
      series: this.data.highcharts.series
    });
  }
}
