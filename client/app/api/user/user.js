import API from 'api/base/base';
const axios = require('axios');

const User = new API({ controller: 'user' });

Object.assign(User, {
  getPosts(payload) {
    return axios.post(`${this.url}/posts`, payload);
  }
});

export default User;
