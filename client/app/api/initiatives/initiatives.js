import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';

const axios = require('axios');

const Initiatives = new API({ controller: 'initiatives' });

Object.assign(Initiatives, {
  archived(payload) {
    return axios.get(appendQueryArgs(`${this.url}/archived`, payload));
  },
  finalizeExpenses(id) {
    return axios.post(appendQueryArgs(`${this.url}/${id}/finalize_expenses`));
  },
  fields(id, payload) {
    return axios.get(appendQueryArgs(`${this.url}/${id}/fields`, payload));
  },
  createFields(id, payload) {
    return axios.post(`${this.url}/${id}/create_field`, payload);
  },
  updates(id, payload) {
    return axios.get(appendQueryArgs(`${this.url}/${id}/updates`, payload));
  },
  updatePrototype(id, payload) {
    return axios.get(appendQueryArgs(`${this.url}/${id}/update_prototype`, payload));
  },
  createUpdates(id, payload) {
    return axios.post(`${this.url}/${id}/create_update`, payload);
  },
  archive(id, payload) {
    return axios.post(`${this.url}/${id}/archive`, payload);
  },
  un_archive(id, payload) {
    return axios.put(`${this.url}/${id}/un_archive`, payload);
  }
});

export default Initiatives;
