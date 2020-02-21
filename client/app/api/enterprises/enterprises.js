import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Enterprises = new API({ controller: 'enterprises' });

Object.assign(Enterprises, {
  getAuthEnterprise(payload) {
    return axios.get(appendQueryArgs(`${this.url}/get_auth_enterprise`, payload));
  },
  getEnterprise() {
    return axios.get(`${this.url}/get_enterprise`);
  },
  updateEnterprise(payload) {
    return axios.post(`${this.url}/update_enterprise`, payload);
  },
  getSsoLink(id, payload) {
    return axios.post(`${this.url}/${id}/sso_link`, payload);
  },
  fields(id, payload) {
    return axios.get(appendQueryArgs(`${this.url}/${id}/fields`, payload));
  },
  createFields(id, payload) {
    return axios.post(`${this.url}/${id}/create_field`, payload);
  }
});

export default Enterprises;
