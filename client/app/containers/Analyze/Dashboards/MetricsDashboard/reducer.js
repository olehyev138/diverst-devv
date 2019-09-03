/*
 *
 * Custom Metrics reducer
 *
 */
import produce from 'immer';
import {
  GET_METRICS_DASHBOARDS_SUCCESS, GET_METRICS_DASHBOARD_SUCCESS,
  METRICS_DASHBOARDS_UNMOUNT
} from './constants';

import {
  GET_CUSTOM_GRAPH_SUCCESS, CUSTOM_GRAPH_UNMOUNT
} from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/constants';

export const initialState = {
  metricsDashboards: [],
  metricsDashboardsTotal: null,
  currentMetricsDashboard: null,
  currentCustomGraph: null
};

/* eslint-disable default-case, no-param-reassign */
function customMetricsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_METRICS_DASHBOARDS_SUCCESS:
        draft.metricsDashboards = action.payload.items;
        draft.metricsDashboardsTotal = action.payload.total;
        break;
      case GET_METRICS_DASHBOARD_SUCCESS:
        draft.currentMetricsDashboard = action.payload.metrics_dashboard;
        break;
      case GET_CUSTOM_GRAPH_SUCCESS:
        draft.currentCustomGraph = action.payload.graph;
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
