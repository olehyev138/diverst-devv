import API from 'api/base/base';

const axios = require('axios');

const Folders = new API({ controller: 'folders' });

Object.assign(Folders, {});

export default Folders;
