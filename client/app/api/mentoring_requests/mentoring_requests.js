import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const MentoringRequests = new API({ controller: 'mentoring_requests' });

Object.assign(MentoringRequests, {
  acceptRequest(id) {
    return axios.post(`${this.url}/accept/${id}`);
  },
  denyRequest(id) {
    return axios.post(`${this.url}/deny/${id}`);
  },
});

export default MentoringRequests;
