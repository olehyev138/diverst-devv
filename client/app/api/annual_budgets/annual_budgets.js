import API from 'api/base/base';
const axios = require('axios');

const AnnualBudgets = new API({ controller: 'annual_budgets' });

Object.assign(AnnualBudgets, {
  currentChildBudgets(payload) {
    return axios.post(`${this.url}/reset`, payload);
  },
});

export default AnnualBudgets;
