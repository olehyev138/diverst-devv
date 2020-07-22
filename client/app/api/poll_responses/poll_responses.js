import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const PollResponses = new API({ controller: 'poll_responses' });

Object.assign(PollResponses, {
  getQuestionnaire(payload) {
    return axios.get(appendQueryArgs(`${this.url}/questionnaire`, payload));
  },
});

export default PollResponses;
