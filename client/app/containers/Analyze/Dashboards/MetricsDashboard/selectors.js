import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectMetricsDashboardsDomain = state => state.metricsDashboards || initialState;

const selectPaginatedMetricsDashboards = () => createSelector(
  selectMetricsDashboardsDomain,
  metricsDashboardsState => metricsDashboardsState.metricsDashboards
);

const selectMetricsDashboardsTotal = () => createSelector(
  selectMetricsDashboardsDomain,
  metricsDashboardsState => metricsDashboardsState.metricsDashboardsTotal
);

const selectMetricsDashboard = () => createSelector(
  selectMetricsDashboardsDomain,
  metricsDashboardsState => metricsDashboardsState.currentMetricsDashboard
);

export { selectPaginatedMetricsDashboards, selectMetricsDashboardsTotal, selectMetricsDashboard };
