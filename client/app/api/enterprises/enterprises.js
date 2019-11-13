import API from 'api/base/base';
const axios = require('axios');

const Enterprises = new API({ controller: 'enterprises' });

Object.assign(Enterprises, {
  getEnterprise() {
    return axios.get(`${this.url}/get_enterprise`);
  },
  updateEnterprise(payload) {
    return axios.post(`${this.url}/update_enterprise`, payload);
  },
  getSsoLink(id, payload) {
    return axios.post(`${this.url}/${id}/sso_link`, payload);
  }
});

export default Enterprises;
