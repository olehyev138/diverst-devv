import API from 'api/base/base';
const axios = require('axios');

const GroupCategories = new API({ controller: 'group_categories' });

Object.assign(GroupCategories, {});

export default GroupCategories;
