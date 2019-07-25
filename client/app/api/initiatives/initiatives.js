import API from 'api/base/base';

const axios = require('axios');

const Initiatives = new API({ controller: 'initiatives' });

Object.assign(Initiatives, {});

export default Initiatives;
