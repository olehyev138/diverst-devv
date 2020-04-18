import { createSelector } from 'reselect';
import { initialState } from 'containers/Analyze/reducer';

import dig from 'object-dig';
import { formatBarGraphData, selectSeriesValues } from 'utils/metricsHelpers';

const selectMetricsDomain = state => state.metrics || initialState;

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

const selectMessagesPerGroup = () => createSelector(
  selectMetricsDomain,
  metricsState => formatBarGraphData(selectSeriesValues(metricsState.metricsData.messagesPerGroup, 0) || [])
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
  selectGrowthOfGroups, selectInitiativesPerGroup, selectMessagesPerGroup,
  selectViewsPerNewsLink, selectViewsPerFolder, selectViewsPerResource,
  selectGrowthOfResources, selectGrowthOfUsers

};
