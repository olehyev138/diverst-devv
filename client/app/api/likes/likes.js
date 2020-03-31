import API from 'api/base/base';
const axios = require('axios');

const Likes = new API({ controller: 'likes' });

Object.assign(Likes, {
  unlike(payload) {
    return axios.post(`${this.url}/unlike`, payload);
  }
});

export default Likes;
