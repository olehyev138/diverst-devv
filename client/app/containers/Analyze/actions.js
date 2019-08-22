/*
 *
 * Metric actions
 *
 */

import {
  GET_GROUP_POPULATION_BEGIN, GET_GROUP_POPULATION_SUCCESS, GET_GROUP_POPULATION_ERROR,
  METRICS_UNMOUNT
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


/* Unmounting */

export function metricsUnmount() {
  return {
    type: METRICS_UNMOUNT
  };
}
