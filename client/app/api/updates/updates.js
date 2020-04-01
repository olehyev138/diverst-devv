import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Updates = new API({ controller: 'updates' });

Object.assign(Updates, {
  prototype(payload) {
    return axios.get(appendQueryArgs(`${this.url}/prototype`, payload));
  },
});

export default Updates;
