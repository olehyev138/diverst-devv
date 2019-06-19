import API from 'api/base/base';
const axios = require('axios');

const Groups = new API({ controller: 'groups' });

Object.assign(Groups, {});

export default Groups;
