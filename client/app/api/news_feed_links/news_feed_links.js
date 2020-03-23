import API from 'api/base/base';
const axios = require('axios');

const NewsFeedLinks = new API({ controller: 'news_feed_links' });

Object.assign(NewsFeedLinks, {
  archive(id, payload) {
    return axios.post(`${this.url}/${id}/archive`, payload);
  },
  un_archive(id, payload) {
    return axios.put(`${this.url}/${id}/un_archive`, payload);
  },
  pin(id, payload) {
    return axios.post(`${this.url}/${id}/pin`, payload);
  },
  un_pin(id, payload) {
    return axios.put(`${this.url}/${id}/un_pin`, payload);
  }
});

export default NewsFeedLinks;
