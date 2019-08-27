/*
 *
 * Metric actions
 *
 */

import {
  GET_GROUP_POPULATION_BEGIN, GET_GROUP_POPULATION_SUCCESS, GET_GROUP_POPULATION_ERROR,
  GET_GROWTH_OF_GROUPS_BEGIN, GET_GROWTH_OF_GROUPS_SUCCESS, GET_GROWTH_OF_GROUPS_ERROR,
  GET_VIEWS_PER_GROUP_BEGIN, GET_VIEWS_PER_GROUP_SUCCESS, GET_VIEWS_PER_GROUP_ERROR,
  METRICS_UNMOUNT,
} from 'containers/Analyze/constants';

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


/* Unmounting */

export function metricsUnmount() {
  return {
    type: METRICS_UNMOUNT
  };
}
