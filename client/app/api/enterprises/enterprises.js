import API from 'api/base/base';
const axios = require('axios');

const Enterprises = new API({ controller: 'enterprises' });

Object.assign(Enterprises, {
  getSsoLink(id, payload) {
    return axios.post(`${this.url}/${id}/sso_link`, payload);
  }
});

export default Enterprises;
