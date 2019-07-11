import API from 'api/base/base';
const axios = require('axios');

const NewsFeedLinks = new API({ controller: 'news_feed_links.js' });

Object.assign(NewsFeedLinks, {});

export default NewsFeedLinks;
