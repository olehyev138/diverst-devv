import API from 'api/base/base';
const axios = require('axios');

const BudgetItems = new API({ controller: 'budget_items' });

Object.assign(BudgetItems, {
  closeBudget(id) {
    return axios.post(`${this.url}/${id}/close`);
  },
});

export default BudgetItems;
