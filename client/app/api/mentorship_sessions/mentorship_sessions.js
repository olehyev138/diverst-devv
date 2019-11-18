import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const MentorshipSessions = new API({ controller: 'mentorship_sessions' });

Object.assign(MentorshipSessions, {

});

export default MentorshipSessions;
