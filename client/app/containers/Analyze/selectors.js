import { createSelector } from 'reselect';
import { initialState } from 'containers/Analyze/reducer';

import dig from 'object-dig';
import { formatBarGraphData } from 'utils/metricsHelpers';

const selectMetricsDomain = state => state.metrics || initialState;

const selectGroupPopulation = () => createSelector(
  selectMetricsDomain,
  metricsState => formatBarGraphData(dig(metricsState.metricsData.groupPopulation, 'series', 0, 'values') || [])
);

const selectGrowthOfGroups = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.growthOfGroups
);

export {
  selectMetricsDomain, selectGroupPopulation, selectGrowthOfGroups
};
