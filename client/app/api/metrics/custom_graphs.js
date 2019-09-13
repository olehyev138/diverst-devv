import API from 'api/base/base';
const axios = require('axios');

const CustomGraphs = new API({ controller: 'metrics/graphs' });

Object.assign(CustomGraphs, {
  data(params) {
    return axios.get(`${this.url}/data`, { params });
  }
});

export default CustomGraphs;
