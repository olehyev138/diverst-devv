import { createSelector } from 'reselect';
import { initialState } from './reducer';
import produce from 'immer';
import dig from 'object-dig';
import { formatBarGraphData, selectSeriesValues } from 'utils/metricsHelpers';

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

const selectIsFormLoading = () => createSelector(
  selectCustomMetricsDomain,
  customMetricsState => customMetricsState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectCustomMetricsDomain,
  customMetricsState => customMetricsState.isCommitting
);

/* Graphs */

const selectCustomGraph = () => createSelector(
  selectCustomMetricsDomain,
  customMetricsState => customMetricsState.currentCustomGraph
);

const selectFormCustomGraph = () => createSelector(
  selectCustomMetricsDomain,
  (customMetricsState) => {
    const customGraph = customMetricsState.currentCustomGraph;
    if (!customGraph) return customGraph;

    return produce(customGraph, (draft) => {
      draft.field = { label: draft.field.title, value: draft.field.id };
      draft.aggregation = draft.aggregation ? { label: draft.aggregation.title, value: draft.aggregation.id } : draft.aggregation;
    });
  }
);

const selectCustomGraphData = graphId => createSelector(
  selectCustomMetricsDomain,
  (customMetricsState) => {
    const series = dig(customMetricsState.currentCustomGraphData, graphId, 'series') || [];
    return series.map(series => ({
      key: series.key,
      values: series.values.map(value => ({ x: value.y, y: value.x, series: series.key }))
    }));
  }
);

export {
  selectPaginatedMetricsDashboards, selectMetricsDashboardsTotal, selectMetricsDashboard,
  selectFormMetricsDashboard, selectCustomGraph, selectFormCustomGraph, selectCustomGraphData,
  selectIsCommitting, selectIsFormLoading
};