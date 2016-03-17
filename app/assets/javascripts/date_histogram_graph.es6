class DateHistogramGraph {
  constructor(dataUrl, $element) {
    this.dataUrl = dataUrl;
    this.$element = $element;
    this.data = {};
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
    this.renderLineChart()
  }

  summedData() {
    let seriesData = this.data.aggregations.my_date_histogram.buckets.map((bucket) => bucket.doc_count);
    let summedSeriesData = [];
    for (let i = 0 ; i < seriesData.length ; i++) {
      let sumSoFar = 0;
      for (let j = 0 ; j < i ; j++) {
        sumSoFar += seriesData[j];
      }

      summedSeriesData[i] = sumSoFar + seriesData[i];
    }

    return summedSeriesData;
  }

  renderLineChart() {
    this.$element.highcharts({
      title: {
        text: "Nb of employees"
      },
      xAxis: {
        categories: this.data.aggregations.my_date_histogram.buckets.map((bucket) => bucket.key_as_string)
      },
      yAxis: {
        title: {
          text: 'Number of employees'
        },
        allowDecimals: false
      },
      tooltip: {
        valueSuffix: ' employees'
      },
      series: [{
        name: 'Employee count',
        data: this.summedData()
      }],
      colors: [this.primaryColor, '#F15E57', '#FE6D4B', '#9FD661', '#40D0AD', '#48C0EB', '#5A9AEF', '#EE85C1']
    });
  }
}