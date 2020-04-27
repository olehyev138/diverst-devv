import API from 'api/base/base';
const axios = require('axios');

const Polls = new API({ controller: 'polls' });

Object.assign(Polls, {});

export default Polls;
