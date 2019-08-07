import API from 'api/base/base';
const axios = require('axios');

const GroupMembers = new API({ controller: 'members' });

Object.assign(GroupMembers, {
  addMembers(payload) {
    return axios.post(`${this.url}/add_members`, payload);
  },
  removeMembers(payload) {
    return axios.post(`${this.url}/remove_members`, payload);
  }
});

export default GroupMembers;
