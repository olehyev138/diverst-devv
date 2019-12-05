import API from 'api/base/base';
const axios = require('axios');

const NewsLinkComments = new API({ controller: 'news_link_comments' });

Object.assign(NewsLinkComments, {});

export default NewsLinkComments;
