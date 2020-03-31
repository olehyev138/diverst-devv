import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';

const axios = require('axios');

const InitiativeUsers = new API({ controller: 'initiative_users' });

Object.assign(InitiativeUsers, {
  leave(payload) {
    return axios.post(`${this.url}/leave`, payload);
  },
  join(payload) {
    return axios.post(`${this.url}/join`, payload);
  }
});

export default InitiativeUsers;
