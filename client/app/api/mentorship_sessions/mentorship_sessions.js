import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const MentorshipSessions = new API({ controller: 'mentorship_sessions' });

Object.assign(MentorshipSessions, {
  acceptInvite(id) {
    return axios.post(`${this.url}/${id}/accept`);
  },
  declineInvite(id) {
    return axios.post(`${this.url}/${id}/decline`);
  },
});

export default MentorshipSessions;
