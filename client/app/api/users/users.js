import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Users = new API({ controller: 'users' });

Object.assign(Users, {
  findEnterprise(payload) {
    return axios.post(`${this.url}/email`, payload);
  },
  getInvitedUser(payload) {
    return axios.post(`${this.url}/signup_token`, payload);
  },
});

export default Users;
