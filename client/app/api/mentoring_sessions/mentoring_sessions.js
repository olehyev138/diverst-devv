import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const MentoringSessions = new API({ controller: 'mentoring_sessions' });

Object.assign(MentoringSessions, {

});

export default MentoringSessions;
