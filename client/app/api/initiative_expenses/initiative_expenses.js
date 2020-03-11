import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';

const axios = require('axios');

const InitiativeExpenses = new API({ controller: 'initiative_expenses' });

Object.assign(InitiativeExpenses, {
});

export default InitiativeExpenses;
