import API from 'api/base/base';
const axios = require('axios');

const NewsLinks = new API({ controller: 'news_links' });

Object.assign(NewsLinks, {});

export default NewsLinks;
