import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';

const axios = require('axios');

const InitiativeUsers = new API({ controller: 'initiative_users' });

Object.assign(InitiativeUsers, {
  remove(payload) {
    return axios.post(`${this.url}/remove`, payload);
  }
});

export default InitiativeUsers;
