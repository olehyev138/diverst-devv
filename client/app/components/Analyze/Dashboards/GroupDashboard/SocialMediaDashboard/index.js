/**
 *
 * Group SocialMediaDashboard
 */

import React from 'react';
import PropTypes from 'prop-types';

import { Grid } from '@material-ui/core';

// Graphs
import NewsPerGroupGraphPage from 'containers/Analyze/Graphs/NewsPerGroupGraphPage';
import ViewsPerNewsLinkGraphPage from 'containers/Analyze/Graphs/ViewsPerNewsLinkGraphPage';

const SocialMediaDashboard = ({ dashboardParams }) => (
  <Grid container spacing={3}>
  </Grid>
);

SocialMediaDashboard.propTypes = {
  dashboardFilters: PropTypes.array
};

export default SocialMediaDashboard;
