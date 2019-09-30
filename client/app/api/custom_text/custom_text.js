import API from 'api/base/base';
const axios = require('axios');

const CustomText = new API({ controller: 'custom_texts' });

Object.assign(CustomText, {});

export default CustomText;
