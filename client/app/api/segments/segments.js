import API from 'api/base/base';
const axios = require('axios');

const Segments = new API({ controller: 'segments' });

Object.assign(Segments, {});

export default Segments;
