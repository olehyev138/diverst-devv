import API from 'api/base/base';
const axios = require('axios');

const PollResponses = new API({ controller: 'poll_responses' });

Object.assign(PollResponses, {});

export default PollResponses;
