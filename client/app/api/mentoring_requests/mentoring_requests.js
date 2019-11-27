import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const MentoringRequests = new API({ controller: 'mentoring_requests' });

Object.assign(MentoringRequests, {
  acceptRequest(id) {
    return axios.post(`${this.url}/${id}/accept`);
  },
  rejectRequest(id) {
    return axios.post(`${this.url}/${id}/reject`);
  },
});

export default MentoringRequests;
