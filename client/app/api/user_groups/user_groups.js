import API from 'api/base/base';
const axios = require('axios');

const UserGroups = new API({ controller: 'user_groups' });

Object.assign(UserGroups, {
  remove(payload) {
    return axios.post(`${this.url}/remove`, payload);
  }
});

export default UserGroups;
