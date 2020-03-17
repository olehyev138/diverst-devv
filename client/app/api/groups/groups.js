import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Groups = new API({ controller: 'groups' });

Object.assign(Groups, {
  initiatives(id, payload) {
    return axios.get(appendQueryArgs(`${this.url}/${id}/initiatives`, payload));
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
  assignLeaders(id, payload) {
    return axios.put(`${this.url}/${id}/assign_leaders`, payload);
  },
  updateCategories(payload) {
    return axios.post(`${this.url}/update_categories`, payload);
  },
});

export default Groups;
