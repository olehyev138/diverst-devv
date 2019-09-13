import API from 'api/base/base';
const axios = require('axios');

const MetricsDashboards = new API({ controller: 'metrics/metrics_dashboards' });

Object.assign(MetricsDashboards, {
});

export default MetricsDashboards;
