import API from 'api/base/base';
const axios = require('axios');

const GroupGraphs = new API({ controller: 'metrics/groups' });

Object.assign(GroupGraphs, {
  // Overview

  groupPopulation(params) {
    return axios.get(`${this.url}/group_population`, { params });
  },

  viewsPerGroup(params) {
    return axios.get(`${this.url}/views_per_group`, { params });
  },

  growthOfGroups(params) {
    return axios.get(`${this.url}/growth_of_groups`, { params });
  },

  // Initiatives

  initiativesPerGroup(params) {
    return axios.get(`${this.url}/initiatives_per_group`, { params });
  },

  // Social Media

  newsPerGroup(params) {
    return axios.get(`${this.url}/news_posts_per_group`, { params });
  },

  viewsPerNewsLink(params) {
    return axios.get(`${this.url}/views_per_news_link`, { params });
  },

  // Resources

  viewsPerFolder(params) {
    return axios.get(`${this.url}/views_per_folder`, { params });
  },

  viewsPerResource(params) {
    return axios.get(`${this.url}/views_per_resource`, { params });
  },

  growthOfResources(params) {
    return axios.get(`${this.url}/growth_of_resources`, { params });
  }
});

export default GroupGraphs;
