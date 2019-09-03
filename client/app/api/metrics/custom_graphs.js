import API from 'api/base/base';
const axios = require('axios');

const CustomGraphs = new API({ controller: 'metrics/graphs' });

Object.assign(CustomGraphs, {
});

export default CustomGraphs;
