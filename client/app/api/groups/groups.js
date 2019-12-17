import API from 'api/base/base';
const axios = require('axios');

const Groups = new API({ controller: 'groups' });

Object.assign(Groups, {
  assignLeaders(id, payload) {
    return axios.put(`${this.url}/${id}/assignLeaders`, payload);
  }
});

export default Groups;
