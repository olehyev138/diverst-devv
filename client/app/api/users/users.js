import API from 'api/base/base';
const axios = require('axios');

const Users = new API({ controller: 'users' });

Object.assign(Users, {
  findEnterprise(payload) {
    return axios.post(`${this.url}/email`, payload);
  }
});

export default Users;
