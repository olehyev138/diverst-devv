import API from 'api/base/base';
const axios = require('axios');

const PolicyGroups = new API({ controller: 'policy_groups' });

Object.assign(PolicyGroups, {
});

export default PolicyGroups;
