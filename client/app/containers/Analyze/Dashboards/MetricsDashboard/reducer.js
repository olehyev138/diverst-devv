/*
 *
 * Custom Metrics reducer
 *
 */
import produce from 'immer';
import {
  GET_METRICS_DASHBOARDS_SUCCESS, GET_METRICS_DASHBOARD_SUCCESS,
  METRICS_DASHBOARDS_UNMOUNT, CREATE_METRICS_DASHBOARD_BEGIN,
  CREATE_METRICS_DASHBOARD_SUCCESS, CREATE_METRICS_DASHBOARD_ERROR,
  UPDATE_METRICS_DASHBOARD_BEGIN, UPDATE_METRICS_DASHBOARD_SUCCESS,
  UPDATE_METRICS_DASHBOARD_ERROR, GET_METRICS_DASHBOARD_BEGIN, GET_METRICS_DASHBOARD_ERROR,
} from './constants';

import {
  GET_CUSTOM_GRAPH_SUCCESS,
  GET_CUSTOM_GRAPH_DATA_SUCCESS,
  DELETE_CUSTOM_GRAPH_SUCCESS,
  CUSTOM_GRAPH_UNMOUNT,
  CREATE_CUSTOM_GRAPH_BEGIN,
  CREATE_CUSTOM_GRAPH_SUCCESS,
  CREATE_CUSTOM_GRAPH_ERROR,
  UPDATE_CUSTOM_GRAPH_BEGIN,
  UPDATE_CUSTOM_GRAPH_SUCCESS,
  UPDATE_CUSTOM_GRAPH_ERROR,
  GET_CUSTOM_GRAPH_BEGIN, GET_CUSTOM_GRAPH_ERROR,
} from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/constants';

export const initialState = {
  isCommitting: false,
  isFormLoading: true,
  metricsDashboards: [],
  metricsDashboardsTotal: null,
  currentMetricsDashboard: null,
  currentCustomGraph: null,
  currentCustomGraphData: {}
};

/* eslint-disable default-case, no-param-reassign */
function customMetricsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_METRICS_DASHBOARDS_SUCCESS:
        draft.metricsDashboards = action.payload.items;
        draft.metricsDashboardsTotal = action.payload.total;
        break;
      case GET_METRICS_DASHBOARD_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_METRICS_DASHBOARD_SUCCESS:
        draft.currentMetricsDashboard = action.payload.metrics_dashboard;
        draft.isFormLoading = false;
        break;
      case GET_METRICS_DASHBOARD_ERROR:
        draft.isFormLoading = false;
        break;
      case GET_CUSTOM_GRAPH_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_CUSTOM_GRAPH_SUCCESS:
        /* Used only for CustomGraph Edit page */
        draft.currentCustomGraph = action.payload.graph;
        draft.isFormLoading = false;
        break;
      case GET_CUSTOM_GRAPH_ERROR:
        draft.isFormLoading = false;
        break;
      case GET_CUSTOM_GRAPH_DATA_SUCCESS:
        draft.currentCustomGraphData[action.payload.id] = action.payload.data;
        break;
      case CREATE_METRICS_DASHBOARD_BEGIN:
      case UPDATE_METRICS_DASHBOARD_BEGIN:
      case CREATE_CUSTOM_GRAPH_BEGIN:
      case UPDATE_CUSTOM_GRAPH_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_METRICS_DASHBOARD_SUCCESS:
      case CREATE_METRICS_DASHBOARD_ERROR:
      case UPDATE_METRICS_DASHBOARD_SUCCESS:
      case UPDATE_METRICS_DASHBOARD_ERROR:
      case CREATE_CUSTOM_GRAPH_SUCCESS:
      case CREATE_CUSTOM_GRAPH_ERROR:
      case UPDATE_CUSTOM_GRAPH_SUCCESS:
      case UPDATE_CUSTOM_GRAPH_ERROR:
        draft.isCommitting = false;
        break;
      case DELETE_CUSTOM_GRAPH_SUCCESS:
        delete draft.currentCustomGraphData[action.payload];
        break;
      case CUSTOM_GRAPH_UNMOUNT:
        draft.currentCustomGraph = null;
        break;
      case METRICS_DASHBOARDS_UNMOUNT:
        return initialState;
    }
  });
}

export default customMetricsReducer;
