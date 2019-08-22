import API from 'api/base/base';
const axios = require('axios');

const GroupGraphs = new API({ controller: 'metrics/groups' });

Object.assign(GroupGraphs, {
  groupPopulation() {
    return axios.get(`${this.url}/group_population`);
  },

  growthOfGroups() {
    return axios.get(`${this.url}/growth_of_groups`);
  }
});

export default GroupGraphs;
