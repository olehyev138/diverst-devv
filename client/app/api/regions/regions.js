import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Regions = new API({ controller: 'regions' });

Object.assign(Regions, {
  groupRegions(payload) {
    return axios.get(appendQueryArgs(`${this.url}/group_regions`, payload));
  },
});

export default Regions;
