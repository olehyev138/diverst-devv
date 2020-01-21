import API from 'api/base/base';
const axios = require('axios');

const Budgets = new API({ controller: 'budgets' });

Object.assign(Budgets, {
});

export default Budgets;
