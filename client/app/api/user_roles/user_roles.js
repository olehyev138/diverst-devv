import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const UserRole = new API({ controller: 'user_roles' });

Object.assign(UserRole, {
});

export default UserRole;
