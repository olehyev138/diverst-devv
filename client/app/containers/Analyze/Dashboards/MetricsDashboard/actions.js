/*
 *
 * MetricsDashboard actions
 *
 */

import {
  GET_METRICS_DASHBOARDS_BEGIN,
  GET_METRICS_DASHBOARDS_SUCCESS,
  GET_METRICS_DASHBOARDS_ERROR,
  CREATE_METRICS_DASHBOARD_BEGIN,
  CREATE_METRICS_DASHBOARD_SUCCESS,
  CREATE_METRICS_DASHBOARD_ERROR,
  DELETE_METRICS_DASHBOARD_BEGIN,
  DELETE_METRICS_DASHBOARD_SUCCESS,
  DELETE_METRICS_DASHBOARD_ERROR,
  GET_METRICS_DASHBOARD_BEGIN,
  GET_METRICS_DASHBOARD_SUCCESS,
  GET_METRICS_DASHBOARD_ERROR,
  UPDATE_METRICS_DASHBOARD_BEGIN,
  UPDATE_METRICS_DASHBOARD_SUCCESS,
  UPDATE_METRICS_DASHBOARD_ERROR,
  METRICS_DASHBOARDS_UNMOUNT
} from './constants';

export function getMetricsDashboardsBegin(payload) {
  return {
    type: GET_METRICS_DASHBOARDS_BEGIN,
    payload
  };
}

export function getMetricsDashboardsSuccess(payload) {
  return {
    type: GET_METRICS_DASHBOARDS_SUCCESS,
    payload
  };
}

export function getMetricsDashboardsError(error) {
  return {
    type: GET_METRICS_DASHBOARDS_ERROR,
    error
  };
}

/* Getting a specific metrics dashboard */

export function getMetricsDashboardBegin(payload) {
  return {
    type: GET_METRICS_DASHBOARD_BEGIN,
    payload
  };
}

export function getMetricsDashboardSuccess(payload) {
  return {
    type: GET_METRICS_DASHBOARD_SUCCESS,
    payload
  };
}

export function getMetricsDashboardError(error) {
  return {
    type: GET_METRICS_DASHBOARD_ERROR,
    error,
  };
}

/* Metrics dashboard creating */

export function createMetricsDashboardBegin(payload) {
  return {
    type: CREATE_METRICS_DASHBOARD_BEGIN,
    payload,
  };
}

export function createMetricsDashboardSuccess(payload) {
  return {
    type: CREATE_METRICS_DASHBOARD_SUCCESS,
    payload,
  };
}

export function createMetricsDashboardError(error) {
  return {
    type: CREATE_METRICS_DASHBOARD_ERROR,
    error,
  };
}

/* Metrics dashboard updating */

export function updateMetricsDashboardBegin(payload) {
  return {
    type: UPDATE_METRICS_DASHBOARD_BEGIN,
    payload,
  };
}

export function updateMetricsDashboardSuccess(payload) {
  return {
    type: UPDATE_METRICS_DASHBOARD_SUCCESS,
    payload,
  };
}

export function updateMetricsDashboardError(error) {
  return {
    type: UPDATE_METRICS_DASHBOARD_ERROR,
    error,
  };
}

/* Metrics dashboard deleting */

export function deleteMetricsDashboardBegin(payload) {
  return {
    type: DELETE_METRICS_DASHBOARD_BEGIN,
    payload,
  };
}

export function deleteMetricsDashboardSuccess(payload) {
  return {
    type: DELETE_METRICS_DASHBOARD_SUCCESS,
    payload,
  };
}

export function deleteMetricsDashboardError(error) {
  return {
    type: DELETE_METRICS_DASHBOARD_ERROR,
    error,
  };
}

export function metricsDashboardsUnmount() {
  return {
    type: METRICS_DASHBOARDS_UNMOUNT,
  };
}
