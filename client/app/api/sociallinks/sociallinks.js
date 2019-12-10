import API from 'api/base/base';
const axios = require('axios');

const SocialLinks = new API({ controller: 'social_links' });

Object.assign(SocialLinks, {});

export default SocialLinks;
