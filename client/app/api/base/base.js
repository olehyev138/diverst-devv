import config from '../../app.config';
import { appendQueryArgs } from 'utils/apiHelpers';

const axios = require('axios');
axios.defaults.baseURL = config.apiUrl;
axios.defaults.headers.common['Diverst-APIKey'] = config.apiKey;

class API {
  constructor(args) {
    this.baseUrl = '/api/v1/';
    this.controller = args.controller;
    this.url = this.baseUrl + this.controller;
  }

  all(opts) {
    return axios.get(appendQueryArgs(this.url, opts));
  }

  get(id) {
    return axios.get(`${this.url}/${id}`);
  }

  create(payload) {
    return axios.post(this.url, payload);
  }

  update(id, payload) {
    return axios.put(`${this.url}/${id}`, payload);
  }

  destroy(id) {
    return axios.delete(`${this.url}/${id}`);
  }
}

export default API;
