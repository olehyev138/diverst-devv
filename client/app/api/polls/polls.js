import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Polls = new API({ controller: 'polls' });

Object.assign(Polls, {
  createAndPublish(payload) {
    return axios.post(`${this.url}/publish`, payload);
  },
  updateAndPublish(id, payload) {
    return axios.put(`${this.url}/${id}/publish`, payload);
  },
  publish(id) {
    return axios.patch(`${this.url}/${id}/publish`, { polls: {} });
  },
});

export default Polls;
