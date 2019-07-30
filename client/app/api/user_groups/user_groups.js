import API from 'api/base/base';
const axios = require('axios');

const UserGroups = new API({ controller: 'user_groups' });

Object.assign(UserGroups, {
});

export default UserGroups;
