class Graph {
  constructor(graphId, $element) {
    this.dataUrl = '/graphs/' + graphId + '/data';
    this.$element = $element;
    this.data = {};

    this.updateData(this.dataUrl);
  }

  updateData() {
    $.get(this.dataUrl, this.onDataUpdate);
  }

  onDataUpdate(data) {
    this.data = data;
    this.attachToElement(this.$element);
  }

  attachToElement() {
    if (this.data.type === "SelectField" && this.data.hasAggregation === false) {
      this.renderPieChart();
    }
  }

  renderPieChart() {

  }
}