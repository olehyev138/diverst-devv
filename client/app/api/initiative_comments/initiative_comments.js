import API from 'api/base/base';
const axios = require('axios');

const InitiativeComments = new API({ controller: 'initiative_comments' });

Object.assign(InitiativeComments, {});

export default InitiativeComments;
