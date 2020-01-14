import API from 'api/base/base';
import {appendQueryArgs} from "utils/apiHelpers";

const axios = require('axios');

const Initiatives = new API({ controller: 'initiatives' });

Object.assign(Initiatives, {
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
  }
});

export default Initiatives;
