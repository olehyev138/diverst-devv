import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';

const axios = require('axios');

const InitiativeUsers = new API({ controller: 'initiative_users' });

Object.assign(InitiativeUsers, {
});

export default InitiativeUsers;
