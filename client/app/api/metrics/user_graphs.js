import API from 'api/base/base';
const axios = require('axios');

const UserGraphs = new API({ controller: 'metrics/users' });

Object.assign(UserGraphs, {
  growthOfUsers(params) {
    return axios.get(`${this.url}/user_growth`, { params });
  },
});

export default UserGraphs;
