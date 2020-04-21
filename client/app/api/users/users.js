import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Users = new API({ controller: 'users' });

Object.assign(Users, {
  findEnterprise(payload) {
    return axios.post(`${this.url}/email`, payload);
  },
  getInvitedUser(payload) {
    return axios.post(`${this.url}/sign_up_token`, payload);
  },
  signUpUser(payload) {
    return axios.post(`${this.url}/sign_up`, payload);
  },
  prototype(payload) {
    return axios.get(appendQueryArgs(`${this.url}/prototype`, payload));
  },
});

export default Users;
