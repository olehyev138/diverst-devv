class TimeSeriesGraph {
  constructor({ dataUrl, element, title, spark = false, from, to }) {
    this.$element = element;
    this.title = title;
    this.spark = spark;
    this.data = [];
    this.from = from;
    this.to = to;
    this.primaryColor = $('.primary-header').css('background-color');
    this.attached = false;
    this.chart = null;
    this.dataUrl = dataUrl;

    this.updateData();
  }

  updateData() {
    this.dataUrl = URI(this.dataUrl).query({
      from: this.from ? +this.from : null,
      to: this.to ? +this.to : null
    });

    $.get(`${this.dataUrl}`, (data) => {
      this.data = data;

      if (this.attached) {
        this.attachToElement();
      }
      else {
        this.attached = true;
        this.attachToElement();
      }
    });
  }

  attachToElement() {
    if (this.spark)
      this.attachSparkLine();
    else
      this.attachLineGraph();
  }

  attachLineGraph() {
    var chart = this.$element.highcharts({
      chart: {
        type: 'line'
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
        headerFormat: '<strong>{series.name}</strong><br>',
        pointFormat: '{point.x:%b %e}: {point.y}'
      },
      series: this.data.highcharts,
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

  attachSparkLine() {
    this.chart = this.$element.highcharts('SparkLine', {
      series: this.data.highcharts,
      tooltip: {
        headerFormat: '',
        pointFormat: '{point.y}'
      },
      xAxis: {
        type: 'datetime'
      }
    });
  }
}
