import API from 'api/base/base';

const axios = require('axios');

const Resources = new API({ controller: 'resources' });

Object.assign(Resources, {
  archive(id, payload) {
    return axios.post(`${this.url}/${id}/archive`, payload);
  }
});

export default Resources;
