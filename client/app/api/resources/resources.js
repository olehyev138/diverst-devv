import API from 'api/base/base';

const axios = require('axios');

const Resources = new API({ controller: 'resources' });

Object.assign(Resources, {});

export default Resources;
