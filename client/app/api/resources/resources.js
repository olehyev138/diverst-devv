import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';

const axios = require('axios');

const Resources = new API({ controller: 'resources' });

Object.assign(Resources, {
  archived(payload) {
    return axios.get(appendQueryArgs(`${this.url}/archived`, { all: true, ...payload }));
  },
  archive(id, payload) {
    return axios.post(`${this.url}/${id}/archive`, payload);
  },
  un_archive(id, payload) {
    return axios.put(`${this.url}/${id}/un_archive`, payload);
  },
  getFileData(payload) {
    if (!payload)
      throw Error('Payload must be a valid ActiveStorage blob path');

    return axios.get(payload, { responseType: 'blob' });
  },
});

export default Resources;
