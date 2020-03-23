import API from 'api/base/base';
const axios = require('axios');

const Budgets = new API({ controller: 'budgets' });

Object.assign(Budgets, {
  approve(id) {
    return axios.post(`${this.url}/${id}/approve`);
  },
  reject(id, payload) {
    return axios.post(`${this.url}/${id}/decline`, payload);
  },
});

export default Budgets;
