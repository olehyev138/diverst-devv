import API from 'api/base/base';
const axios = require('axios');

const GroupCategoryTypes = new API({ controller: 'group_category_types' });

Object.assign(GroupCategoryTypes, {});

export default GroupCategoryTypes;
