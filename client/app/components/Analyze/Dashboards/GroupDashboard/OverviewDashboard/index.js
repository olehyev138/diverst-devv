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

const OverviewDashboard = ({ dashboardParams }) => (
  <Grid container spacing={3}>
    <Grid item xs={12}>
      <GroupPopulationGraphPage dashboardParams={dashboardParams} />
    </Grid>

    <Grid item xs={12}>
      <ViewsPerGroupGraphPage dashboardParams={dashboardParams} />
    </Grid>

    <Grid item xs={12}>
      <GrowthOfGroupsGraphPage dashboardParams={dashboardParams} />
    </Grid>
  </Grid>
);

OverviewDashboard.propTypes = {
  dashboardParams: PropTypes.object
};

export default OverviewDashboard;
