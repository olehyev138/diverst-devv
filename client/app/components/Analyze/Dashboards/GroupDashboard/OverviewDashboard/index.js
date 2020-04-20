/**
 *
 * Group OverviewDashboard
 */

import React from 'react';
import PropTypes from 'prop-types';

import { Grid } from '@material-ui/core';

// Graphs
import GroupPopulationGraphPage from 'containers/Analyze/Graphs/GroupPopulationGraphPage';
import ViewsPerGroupGraphPage from 'containers/Analyze/Graphs/ViewsPerGroupGraphPage';
import GrowthOfGroupsGraphPage from 'containers/Analyze/Graphs/GrowthOfGroupsGraphPage';
import InitiativesPerGroupGraphPage from 'containers/Analyze/Graphs/InitiativesPerGroupGraphPage';

const OverviewDashboard = ({ dashboardFilters }) => (
  <Grid container spacing={3}>
    <Grid item xs={12}>
      <GroupPopulationGraphPage dashboardFilters={dashboardFilters} />
    </Grid>
    <Grid item xs={12}>
      <GrowthOfGroupsGraphPage dashboardFilters={dashboardFilters} />
    </Grid>
  </Grid>
);

OverviewDashboard.propTypes = {
  dashboardFilters: PropTypes.array
};

export default OverviewDashboard;
