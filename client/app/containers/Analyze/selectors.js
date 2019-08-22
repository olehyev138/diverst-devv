import { createSelector } from 'reselect';
import { initialState } from 'containers/Analyze/reducer';

const selectMetricsDomain = state => state.metrics || initialState;

const selectGroupPopulation = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.groupPopulation
);

const selectGrowthOfGroups = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.growthOfGroups
);

export {
  selectMetricsDomain, selectGroupPopulation, selectGrowthOfGroups
};
