import API from 'api/base/base';
const axios = require('axios');

const BudgetItems = new API({ controller: 'budget_items' });

Object.assign(BudgetItems, {
});

export default BudgetItems;
