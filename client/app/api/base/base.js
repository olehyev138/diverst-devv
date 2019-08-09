import config from '../../app.config';

const axios = require('axios');
axios.defaults.headers.common['Diverst-APIKey'] = config.apiKey;

class API {
  constructor(args) {
    this.baseUrl = `/api/v1/`;
    this.controller = args.controller;
    this.url = this.baseUrl + this.controller;
  }

  all(opts) {
    let { url } = this;

    // append query arguments
    if (opts) {
      url += '?';
      for (const arg of Object.keys(opts)) {
        if (url.indexOf('?') !== url.length - 1)
          url += '&';

        if (Array.isArray(opts[arg]))
          url += `${arg}=${JSON.stringify(opts[arg])}`;
        else
          url += `${arg}=${opts[arg]}`;
      }
    }

    return axios.get(url);
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
