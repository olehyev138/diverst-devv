import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const BudgetUsers = new API({ controller: 'budget_users' });

Object.assign(BudgetUsers, {
  finalizeExpenses(id) {
    return axios.post(appendQueryArgs(`${this.url}/${id}/finalize_expenses`));
  },
});

export default BudgetUsers;
