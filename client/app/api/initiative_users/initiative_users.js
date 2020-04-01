import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';

const axios = require('axios');

const InitiativeUsers = new API({ controller: 'initiative_users' });

Object.assign(InitiativeUsers, {
  join(payload) {
    return axios.post(`${this.url}/join`, payload);
  },
  leave(payload) {
    return axios.post(`${this.url}/leave`, payload);
  }
});

export default InitiativeUsers;
