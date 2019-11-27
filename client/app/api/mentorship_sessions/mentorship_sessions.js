import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const MentorshipSessions = new API({ controller: 'mentorship_sessions' });

Object.assign(MentorshipSessions, {
  acceptInvite(payload) {
    return axios.post(`${this.url}/accept`, payload);
  },
  declineInvite(payload) {
    return axios.post(`${this.url}/decline`, payload);
  },
});

export default MentorshipSessions;
