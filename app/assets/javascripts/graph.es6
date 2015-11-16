class Graph {
  constructor(graphId, $element) {
    this.dataUrl = '/graphs/' + graphId + '/data';
    this.$element = $element;
    this.data = {};

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
    if (this.data.type === "NumericField")
      this.renderBarChart()
    else if (this.data.type === "CheckboxField" || this.data.type === "SelectField")
      if (this.data.hasAggregation)
        this.renderBarChart()
      else
        this.renderPieChart()
  }

  renderBarChart() {
    this.$element.highcharts({
      chart: {
        type: 'bar',
        style: {
          fontFamily: 'Helvetica Neue, sans-serif'
        }
      },
      title: {
        text: ''
      },
      xAxis: {
        categories: this.data.highcharts.categories,
        title: {
          text: this.data.highcharts.xAxisTitle
        }
      },
      yAxis: {
        min: 0,
        title: {
          text: 'Nb of employees'
        },
        allowDecimals: false
      },
      plotOptions: {
        series: {
          stacking: 'normal'
        }
      },
      tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
          '<td style="padding:0"><b>{point.y} employees</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
      },
      series: this.data.highcharts.series
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
      title: {
        text: ''
      },
      series: this.data.highcharts.series,
      tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="padding:0"><b>{point.y} employees</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
      }
    });
  }
}