import API from 'api/base/base';
import { appendQueryArgs } from 'utils/apiHelpers';
const axios = require('axios');

const NewsFeedLinks = new API({ controller: 'news_feed_links' });

Object.assign(NewsFeedLinks, {
  archived(payload) {
    return axios.get(appendQueryArgs(`${this.url}/archived`, payload));
  },
  archive(id, payload) {
    return axios.post(`${this.url}/${id}/archive`, payload);
  },
  un_archive(id, payload) {
    return axios.put(`${this.url}/${id}/un_archive`, payload);
  },
  approve(id, payload = null) {
    return axios.post(`${this.url}/${id}/approve`, payload);
  },
  pin(id, payload) {
    return axios.post(`${this.url}/${id}/pin`, payload);
  },
  un_pin(id, payload) {
    return axios.put(`${this.url}/${id}/un_pin`, payload);
  }
});

export default NewsFeedLinks;
