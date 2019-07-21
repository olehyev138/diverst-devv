import API from 'api/base/base';
const axios = require('axios');

const GroupMessageComments = new API({ controller: 'group_message_comments' });

Object.assign(GroupMessageComments, {});

export default GroupMessageComments;
