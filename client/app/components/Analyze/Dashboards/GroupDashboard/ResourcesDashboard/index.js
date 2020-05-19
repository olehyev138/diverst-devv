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

const ResourcesDashboard = ({ dashboardFilters }) => (
  <Grid container spacing={3}>
    <Grid item xs={12}>
      <ViewsPerFolderGraphPage dashboardFilters={dashboardFilters} />
    </Grid>
  </Grid>
);

ResourcesDashboard.propTypes = {
  dashboardFilters: PropTypes.array
};

export default ResourcesDashboard;
