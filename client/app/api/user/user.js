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
  },

  getAllEvents(payload) {
    return axios.get(appendQueryArgs(`${this.url}/all_events`, payload));
  },

  getDownloads(payload) {
    return axios.get(appendQueryArgs(`${this.url}/downloads`, payload));
  }
});

export default User;
