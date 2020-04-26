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

export function getGroupOverviewMetricsError(payload) {
  return {
    type: GET_GROUP_OVERVIEW_METRICS_ERROR,
    payload
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
    type: GET_GROUP_SPECIFIC_METRICS_BEGIN,
    payload
  };
}

export function getGroupSpecificMetricsError(payload) {
  return {
    type: GET_GROUP_SPECIFIC_METRICS_ERROR,
    payload
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

export function getGrowthOfGroupsError(payload) {
  return {
    type: GET_GROWTH_OF_GROUPS_ERROR,
    payload
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

export function getViewsPerGroupError(payload) {
  return {
    type: GET_VIEWS_PER_GROUP_ERROR,
    payload
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

export function getInitiativesPerGroupError(payload) {
  return {
    type: GET_INITIATIVES_PER_GROUP_ERROR,
    payload
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

export function getNewsPerGroupError(payload) {
  return {
    type: GET_NEWS_PER_GROUP_ERROR,
    payload
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

export function getViewsPerNewsLinkError(payload) {
  return {
    type: GET_VIEWS_PER_NEWS_LINK_ERROR,
    payload
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

export function getViewsPerFolderError(payload) {
  return {
    type: GET_VIEWS_PER_FOLDER_ERROR,
    payload
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

export function getViewsPerResourceError(payload) {
  return {
    type: GET_VIEWS_PER_RESOURCE_ERROR,
    payload
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

export function getGrowthOfResourcesError(payload) {
  return {
    type: GET_GROWTH_OF_RESOURCES_ERROR,
    payload
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

export function getGrowthOfUsersError(payload) {
  return {
    type: GET_GROWTH_OF_USERS_ERROR,
    payload
  };
}

/* Unmounting */

export function metricsUnmount() {
  return {
    type: METRICS_UNMOUNT
  };
}
