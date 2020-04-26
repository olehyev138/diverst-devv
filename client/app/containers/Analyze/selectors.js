import { createSelector } from 'reselect';
import { initialState } from 'containers/Analyze/reducer';

import dig from 'object-dig';
import { formatBarGraphData, selectSeriesValues } from 'utils/metricsHelpers';

const selectMetricsDomain = state => state.metrics || initialState;

const selectGroupOverviewMetrics = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.groupOverviewMetrics
);

const selectGroupSpecificMetrics = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.groupSpecificMetrics
);

const selectGroupPopulation = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.groupPopulation
);

const selectViewsPerGroup = () => createSelector(
  selectMetricsDomain,
  metricsState => formatBarGraphData(selectSeriesValues(metricsState.metricsData.viewsPerGroup, 0) || [])
);

const selectGrowthOfGroups = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.growthOfGroups
);

const selectInitiativesPerGroup = () => createSelector(
  selectMetricsDomain,
  metricsState => formatBarGraphData(selectSeriesValues(metricsState.metricsData.initiativesPerGroup, 0) || [])
);

const selectNewsPerGroup = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.newsPerGroup
);

const selectViewsPerNewsLink = () => createSelector(
  selectMetricsDomain,
  metricsState => formatBarGraphData(selectSeriesValues(metricsState.metricsData.viewsPerNewsLink, 0) || [])
);

const selectViewsPerFolder = () => createSelector(
  selectMetricsDomain,
  metricsState => formatBarGraphData(selectSeriesValues(metricsState.metricsData.viewsPerFolder, 0) || [])
);

const selectViewsPerResource = () => createSelector(
  selectMetricsDomain,
  metricsState => formatBarGraphData(selectSeriesValues(metricsState.metricsData.viewsPerResource, 0) || [])
);

const selectGrowthOfResources = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.growthOfResources
);

const selectGrowthOfUsers = () => createSelector(
  selectMetricsDomain,
  metricsState => metricsState.metricsData.growthOfUsers
);


export {
  selectMetricsDomain, selectGroupPopulation, selectViewsPerGroup,
  selectGrowthOfGroups, selectInitiativesPerGroup, selectNewsPerGroup,
  selectViewsPerNewsLink, selectViewsPerFolder, selectViewsPerResource,
  selectGrowthOfResources, selectGrowthOfUsers, selectGroupOverviewMetrics,
  selectGroupSpecificMetrics
};
