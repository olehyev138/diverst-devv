import API from 'api/base/base';
const axios = require('axios');

const GroupGraphs = new API({ controller: 'metrics/groups' });

Object.assign(GroupGraphs, {
  groupPopulation(params) {
    return axios.get(`${this.url}/group_population`, { params });
  },

  growthOfGroups(params) {
    return axios.get(`${this.url}/growth_of_groups`, { params });
  }
});

export default GroupGraphs;
