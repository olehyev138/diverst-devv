import API from '../base/base';
const axios = require('axios');

const Sessions = new API({ controller: 'sessions' });

Object.assign(Sessions, {
  logout() {
    return axios.delete(`${this.url}/logout`);
  }
});

export default Sessions;
