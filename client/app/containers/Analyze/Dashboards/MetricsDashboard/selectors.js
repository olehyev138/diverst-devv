import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectMetricsDashboardsDomain = state => state.metricsDashboards || initialState;

const selectPaginatedMetricsDashboards = () => createSelector(
  selectMetricsDashboardsDomain,
  metricsDashboardsState => metricsDashboardsState.metrics_dashboards
);

const selectMetricsDashboardsTotal = () => createSelector(
  selectMetricsDashboardsDomain,
  metricsDashboardsState => metricsDashboardsState.metrics_dashboardsTotal
);

const selectMetricsDashboard = () => createSelector(
  selectMetricsDashboardsDomain,
  metricsDashboardsState => metricsDashboardsState.currentMetricsDashboard
);

export { selectPaginatedMetricsDashboards, selectMetricsDashboardsTotal, selectMetricsDashboard };
