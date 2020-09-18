/*
 *
 * Metric actions
 *
 */

import {
  GET_GROUP_OVERVIEW_METRICS_BEGIN, GET_GROUP_OVERVIEW_METRICS_SUCCESS, GET_GROUP_OVERVIEW_METRICS_ERROR,
  GET_GROUP_SPECIFIC_METRICS_BEGIN, GET_GROUP_SPECIFIC_METRICS_SUCCESS, GET_GROUP_SPECIFIC_METRICS_ERROR,
  GET_GROUP_POPULATION_BEGIN, GET_GROUP_POPULATION_SUCCESS, GET_GROUP_POPULATION_ERROR,
  GET_GROWTH_OF_GROUPS_BEGIN, GET_GROWTH_OF_GROUPS_SUCCESS, GET_GROWTH_OF_GROUPS_ERROR,
  GET_VIEWS_PER_GROUP_BEGIN, GET_VIEWS_PER_GROUP_SUCCESS, GET_VIEWS_PER_GROUP_ERROR,
  GET_INITIATIVES_PER_GROUP_BEGIN, GET_INITIATIVES_PER_GROUP_SUCCESS, GET_INITIATIVES_PER_GROUP_ERROR,
  GET_NEWS_PER_GROUP_BEGIN, GET_NEWS_PER_GROUP_SUCCESS, GET_NEWS_PER_GROUP_ERROR,
  GET_VIEWS_PER_NEWS_LINK_BEGIN, GET_VIEWS_PER_NEWS_LINK_SUCCESS, GET_VIEWS_PER_NEWS_LINK_ERROR,
  GET_VIEWS_PER_FOLDER_BEGIN, GET_VIEWS_PER_FOLDER_SUCCESS, GET_VIEWS_PER_FOLDER_ERROR,
  GET_VIEWS_PER_RESOURCE_BEGIN, GET_VIEWS_PER_RESOURCE_SUCCESS, GET_VIEWS_PER_RESOURCE_ERROR,
  GET_GROWTH_OF_RESOURCES_BEGIN, GET_GROWTH_OF_RESOURCES_SUCCESS, GET_GROWTH_OF_RESOURCES_ERROR,
  GET_GROWTH_OF_USERS_BEGIN, GET_GROWTH_OF_USERS_SUCCESS, GET_GROWTH_OF_USERS_ERROR,
  METRICS_UNMOUNT,
} from 'containers/Analyze/constants';

/* Group overview metrics */

export function getGroupOverviewMetricsBegin(payload) {
  return {
    type: GET_GROUP_OVERVIEW_METRICS_BEGIN,
    payload
  };
}

export function getGroupOverviewMetricsSuccess(payload) {
  return {
    type: GET_GROUP_OVERVIEW_METRICS_SUCCESS,
    payload
  };
}

export function getGroupOverviewMetricsError(error) {
  return {
    type: GET_GROUP_OVERVIEW_METRICS_ERROR,
    error
  };
}

/* Group specific metrics */

export function getGroupSpecificMetricsBegin(payload) {
  return {
    type: GET_GROUP_SPECIFIC_METRICS_BEGIN,
    payload
  };
}

export function getGroupSpecificMetricsSuccess(payload) {
  return {
    type: GET_GROUP_SPECIFIC_METRICS_SUCCESS,
    payload
  };
}

export function getGroupSpecificMetricsError(error) {
  return {
    type: GET_GROUP_SPECIFIC_METRICS_ERROR,
    error
  };
}

/* Group population */

export function getGroupPopulationBegin(payload) {
  return {
    type: GET_GROUP_POPULATION_BEGIN,
    payload
  };
}

export function getGroupPopulationSuccess(payload) {
  return {
    type: GET_GROUP_POPULATION_SUCCESS,
    payload
  };
}

export function getGroupPopulationError(error) {
  return {
    type: GET_GROUP_POPULATION_ERROR,
    error,
  };
}

/* Growth of groups */

export function getGrowthOfGroupsBegin(payload) {
  return {
    type: GET_GROWTH_OF_GROUPS_BEGIN,
    payload
  };
}

export function getGrowthOfGroupsSuccess(payload) {
  return {
    type: GET_GROWTH_OF_GROUPS_SUCCESS,
    payload
  };
}

export function getGrowthOfGroupsError(error) {
  return {
    type: GET_GROWTH_OF_GROUPS_ERROR,
    error
  };
}

/* Views per Group */

export function getViewsPerGroupBegin(payload) {
  return {
    type: GET_VIEWS_PER_GROUP_BEGIN,
    payload
  };
}

export function getViewsPerGroupSuccess(payload) {
  return {
    type: GET_VIEWS_PER_GROUP_SUCCESS,
    payload
  };
}

export function getViewsPerGroupError(error) {
  return {
    type: GET_VIEWS_PER_GROUP_ERROR,
    error
  };
}

/* Initiatives per Group */

export function getInitiativesPerGroupBegin(payload) {
  return {
    type: GET_INITIATIVES_PER_GROUP_BEGIN,
    payload
  };
}

export function getInitiativesPerGroupSuccess(payload) {
  return {
    type: GET_INITIATIVES_PER_GROUP_SUCCESS,
    payload
  };
}

export function getInitiativesPerGroupError(error) {
  return {
    type: GET_INITIATIVES_PER_GROUP_ERROR,
    error
  };
}

/* News per Group */

export function getNewsPerGroupBegin(payload) {
  return {
    type: GET_NEWS_PER_GROUP_BEGIN,
    payload
  };
}

export function getNewsPerGroupSuccess(payload) {
  return {
    type: GET_NEWS_PER_GROUP_SUCCESS,
    payload
  };
}

export function getNewsPerGroupError(error) {
  return {
    type: GET_NEWS_PER_GROUP_ERROR,
    error
  };
}

/* Views per News Link */

export function getViewsPerNewsLinkBegin(payload) {
  return {
    type: GET_VIEWS_PER_NEWS_LINK_BEGIN,
    payload
  };
}

export function getViewsPerNewsLinkSuccess(payload) {
  return {
    type: GET_VIEWS_PER_NEWS_LINK_SUCCESS,
    payload
  };
}

export function getViewsPerNewsLinkError(error) {
  return {
    type: GET_VIEWS_PER_NEWS_LINK_ERROR,
    error
  };
}

/* Views per Folder */

export function getViewsPerFolderBegin(payload) {
  return {
    type: GET_VIEWS_PER_FOLDER_BEGIN,
    payload
  };
}

export function getViewsPerFolderSuccess(payload) {
  return {
    type: GET_VIEWS_PER_FOLDER_SUCCESS,
    payload
  };
}

export function getViewsPerFolderError(error) {
  return {
    type: GET_VIEWS_PER_FOLDER_ERROR,
    error
  };
}

/* Views per Resource */

export function getViewsPerResourceBegin(payload) {
  return {
    type: GET_VIEWS_PER_RESOURCE_BEGIN,
    payload
  };
}

export function getViewsPerResourceSuccess(payload) {
  return {
    type: GET_VIEWS_PER_RESOURCE_SUCCESS,
    payload
  };
}

export function getViewsPerResourceError(error) {
  return {
    type: GET_VIEWS_PER_RESOURCE_ERROR,
    error
  };
}

/* Growth of Resources */

export function getGrowthOfResourcesBegin(payload) {
  return {
    type: GET_GROWTH_OF_RESOURCES_BEGIN,
    payload
  };
}

export function getGrowthOfResourcesSuccess(payload) {
  return {
    type: GET_GROWTH_OF_RESOURCES_SUCCESS,
    payload
  };
}

export function getGrowthOfResourcesError(error) {
  return {
    type: GET_GROWTH_OF_RESOURCES_ERROR,
    error
  };
}

/* Growth of Users */

export function getGrowthOfUsersBegin(payload) {
  return {
    type: GET_GROWTH_OF_USERS_BEGIN,
    payload
  };
}

export function getGrowthOfUsersSuccess(payload) {
  return {
    type: GET_GROWTH_OF_USERS_SUCCESS,
    payload
  };
}

export function getGrowthOfUsersError(error) {
  return {
    type: GET_GROWTH_OF_USERS_ERROR,
    error
  };
}

/* Unmounting */

export function metricsUnmount() {
  return {
    type: METRICS_UNMOUNT
  };
}
