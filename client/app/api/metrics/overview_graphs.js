import API from 'api/base/base';
const axios = require('axios');

const OverviewGraphs = new API({ controller: 'metrics/overview' });

Object.assign(OverviewGraphs, {
  overviewMetrics(params) {
    return axios.get(`${this.url}/overview_metrics`, { params });
  },
});

export default OverviewGraphs;
