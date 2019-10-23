import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Users = new API({ controller: 'users' });

Object.assign(Users, {
  findEnterprise(payload) {
    return axios.post(`${this.url}/email`, payload);
  },
  allExcept(id, opts) {
    return axios.get(appendQueryArgs(`${this.url}/${id}/index_except`, opts));
  }
});

export default Users;
