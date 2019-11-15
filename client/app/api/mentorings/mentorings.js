import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const Mentoring = new API({ controller: 'mentorings' });

Object.assign(Mentoring, {
  removeMentorship(payload) {
    return axios.post(`${this.url}/delete_mentorship`, payload);
  }
});

export default Mentoring;
