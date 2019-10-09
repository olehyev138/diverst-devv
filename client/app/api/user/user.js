import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const User = new API({ controller: 'user' });

Object.assign(User, {
  getPosts(payload) {
    return axios.get(appendQueryArgs(`${this.url}/posts`, payload));
  },

  getJoinedEvents(payload) {
    return axios.get(appendQueryArgs(`${this.url}/joined_events`, payload));
  }
});

export default User;
