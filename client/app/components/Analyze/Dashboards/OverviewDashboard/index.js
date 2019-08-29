/**
 *
 * OverviewDashboard
 */

import React from 'react';
import PropTypes from 'prop-types';

import { Grid } from '@material-ui/core';

// Graphs

const OverviewDashboard = ({ dashboardParams }) => (
  <Grid container spacing={3}>
  </Grid>
);

OverviewDashboard.propTypes = {
  dashboardParams: PropTypes.object
};

export default OverviewDashboard;
