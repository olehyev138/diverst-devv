import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const User = new API({ controller: 'user' });

Object.assign(User, {
  getUserData() {
    return axios.get(`${this.url}/user_data`);
  },
  getPosts(payload) {
    return axios.get(appendQueryArgs(`${this.url}/posts`, payload));
  },

  getDownloads(payload) {
    return axios.get(appendQueryArgs(`${this.url}/downloads`, payload));
  },

  getDownloadData(payload) {
    if (!payload)
      throw Error('Payload must be a valid ActiveStorage blob path');

    return axios.get(payload, { responseType: 'blob' });
  },
});

export default User;
