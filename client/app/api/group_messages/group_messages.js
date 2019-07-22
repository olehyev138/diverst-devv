import API from 'api/base/base';
const axios = require('axios');

const GroupMessages = new API({ controller: 'group_messages' });

Object.assign(GroupMessages, {});

export default GroupMessages;
