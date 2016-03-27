class TimeSeriesGraph {
  constructor(dataUrl, $element, title, spark = false) {
    this.dataUrl = dataUrl;
    this.$element = $element;
    this.title = title;
    this.spark = spark;
    this.data = [];
    this.primaryColor = $('.primary-header').css('background-color');

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
    this.render();
  }

  render() {
    if (this.spark)
      this.renderSparkLine();
    else
      this.renderLineChart;
  }

  renderLineChart() {
    this.$element.highcharts({
      chart: {
        type: 'spline'
      },
      title: {
        text: this.title
      },
      xAxis: {
        type: 'datetime',
        dateTimeLabelFormats: {
          month: '%b',
          day: '%b %e',
        },
        title: {
          text: 'Date'
        }
      },
      yAxis: {
        allowDecimals: false
      },
      legend: {
        enabled: false
      },
      tooltip: {
        headerFormat: '<b>{point.x:%b %e}</b><br>',
        pointFormat: '{point.y}'
      },
      series: [{
        name: this.title,
        data: this.data
      }],
      plotOptions: {
        spline: {
          marker: {
            enabled: true
          }
        }
      },
      credits: {
        enabled: false
      },
      colors: [this.primaryColor, '#F15E57', '#FE6D4B', '#9FD661', '#40D0AD', '#48C0EB', '#5A9AEF', '#EE85C1']
    });
  }

  renderSparkLine() {
    this.$element.highcharts('SparkLine', {
      series: [{
        data: this.data,
        pointStart: 1
      }],
      tooltip: {
        headerFormat: '',
        pointFormat: '<b>{point.y}</b>'
      },
      xAxis: {
        type: 'datetime'
      }
    });
  }
}