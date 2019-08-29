/**
 *
 * Group ResourcesDashboard
 */

import React from 'react';
import PropTypes from 'prop-types';

import { Grid } from '@material-ui/core';

// Graphs
import ViewsPerFolderGraphPage from 'containers/Analyze/Graphs/ViewsPerFolderGraphPage';
import ViewsPerResourceGraphPage from 'containers/Analyze/Graphs/ViewsPerResourceGraphPage';
import GrowthOfResourcesGraphPage from 'containers/Analyze/Graphs/GrowthOfResourcesGraphPage';

const ResourcesDashboard = ({ dashboardParams }) => (
  <Grid container spacing={3}>
    <Grid item xs={12}>
      <ViewsPerFolderGraphPage dashboardParams={dashboardParams} />
    </Grid>
    <Grid item xs={12}>
      <ViewsPerResourceGraphPage dashboardParams={dashboardParams} />
    </Grid>
    <Grid item xs={12}>
      <GrowthOfResourcesGraphPage dashboardParams={dashboardParams} />
    </Grid>
  </Grid>
);

ResourcesDashboard.propTypes = {
  dashboardParams: PropTypes.object
};

export default ResourcesDashboard;
