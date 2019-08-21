import API from 'api/base/base';
const axios = require('axios');

const GroupGraphs = new API({ controller: 'groups' });

Object.assign(GroupGraphs, {
  groupPopulation() {
    return axios.get(`${this.url}/group_population`);
  }
});

export default GroupGraphs;
