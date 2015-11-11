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
      this.renderBarChart(this.data.highcharts);
  }

  renderBarChart(data) {
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
        categories: data.ranges,
        title: {
          text: data.xAxisTitle
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
      series: data.series
    });
  }

  renderPieChart(data) {
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
      series: [{
        name: data.fieldTitle,
        data: data.seriesData
      }],
      tooltip: {
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
          '<td style="padding:0"><b>{point.y} employees</b></td></tr>',
        footerFormat: '</table>',
        shared: true,
        useHTML: true
      },
      plotOptions: {
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      },
      colors: ['#7B77C9']
    });
  }
}