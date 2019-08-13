import API from 'api/base/base';

const axios = require('axios');

const Outcomes = new API({ controller: 'outcomes' });

Object.assign(Outcomes, {});

export default Outcomes;
