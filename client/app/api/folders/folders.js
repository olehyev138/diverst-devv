import API from 'api/base/base';
const axios = require('axios');

const Folders = new API({ controller: 'folders' });

Object.assign(Folders, {
  validatePassword(payload) {
    return axios.post(`${this.url}/${payload.id}/password`, payload);
  }
});

export default Folders;
