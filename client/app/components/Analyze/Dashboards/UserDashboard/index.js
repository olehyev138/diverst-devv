/**
 *
 * UserDashboard
 */

import React from 'react';
import PropTypes from 'prop-types';

import { Grid } from '@material-ui/core';

// Graphs
import GrowthOfUsersGraphPage from 'containers/Analyze/Graphs/GrowthOfUsersGraphPage';

const UserDashboard = () => (
  <Grid container spacing={3}>
    <Grid item xs={12}>
      <GrowthOfUsersGraphPage />
    </Grid>
  </Grid>
);

UserDashboard.propTypes = {
  dashboardParams: PropTypes.object
};

export default UserDashboard;
