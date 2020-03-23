import API from 'api/base/base';
const axios = require('axios');

const UserGroups = new API({ controller: 'user_groups' });

Object.assign(UserGroups, {
  join(payload) {
    return axios.post(`${this.url}/join`, payload);
  },
  leave(payload) {
    return axios.post(`${this.url}/leave`, payload);
  }
});

export default UserGroups;
