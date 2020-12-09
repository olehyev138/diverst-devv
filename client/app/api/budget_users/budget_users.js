import API from 'api/base/base';
const axios = require('axios');

const BudgetUsers = new API({ controller: 'budget_users' });

Object.assign(BudgetUsers, {
});

export default BudgetUsers;
