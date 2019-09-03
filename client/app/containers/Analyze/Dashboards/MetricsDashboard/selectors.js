import { createSelector } from 'reselect';
import { initialState } from './reducer';
import produce from 'immer';

const selectCustomMetricsDomain = state => state.customMetrics || initialState;

/* Dashboards */

const selectPaginatedMetricsDashboards = () => createSelector(
  selectCustomMetricsDomain,
  customMetricsState => customMetricsState.metricsDashboards
);

const selectMetricsDashboardsTotal = () => createSelector(
  selectCustomMetricsDomain,
  customMetricsState => customMetricsState.metricsDashboardsTotal
);

const selectMetricsDashboard = () => createSelector(
  selectCustomMetricsDomain,
  customMetricsState => customMetricsState.currentMetricsDashboard
);

const selectFormMetricsDashboard = () => createSelector(
  selectCustomMetricsDomain,
  (customMetricsState) => {
    const dashboard = customMetricsState.currentMetricsDashboard;
    if (!dashboard) return dashboard;

    return produce(dashboard, (draft) => {
      draft.groups = draft.groups.map(g => ({ label: g.name, value: g.id }));
    });
  }
);

/* Graphs */

const selectCustomGraph = () => createSelector(
  selectCustomMetricsDomain,
  customMetricsState => customMetricsState.currentCustomGraph
);

const selectFormCustomGraph = () => createSelector(
  selectCustomMetricsDomain,
  (customMetricsState) => {
    // TODO
  }
);


export {
  selectPaginatedMetricsDashboards, selectMetricsDashboardsTotal, selectMetricsDashboard,
  selectFormMetricsDashboard, selectCustomGraph, selectFormCustomGraph
};
