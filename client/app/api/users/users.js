import API from '../base/base';
const axios = require('axios');

const Users = new API({ controller: 'users' });

Object.assign(Users, {
  findCompany(payload) {
    return axios.post(`${this.url}/email`, payload);
  }
});

export default Users;
