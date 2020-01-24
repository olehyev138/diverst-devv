import API from 'api/base/base';
const axios = require('axios');

const Budgets = new API({ controller: 'budgets' });

Object.assign(Budgets, {
  accept(id) {
    return axios.post(`${this.url}/${id}/accept`);
  },
  reject(id, payload) {
    return axios.post(`${this.url}/${id}/reject`, payload);
  },
});

export default Budgets;
