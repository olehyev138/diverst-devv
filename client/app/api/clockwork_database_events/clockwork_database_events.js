import API from 'api/base/base';
const axios = require('axios');

const EmailEvents = new API({ controller: 'clockwork_database_events' });

Object.assign(EmailEvents, {
});

export default EmailEvents;
