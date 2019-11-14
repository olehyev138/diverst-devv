import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const MentoringRequests = new API({ controller: 'mentoring_requests' });

Object.assign(MentoringRequests, {

});

export default MentoringRequests;
