/**
 *
 * GroupDashboardLinks
 */

import React from 'react';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import {
  Grid, Tabs, Tab, Paper
} from '@material-ui/core';

const GroupDashboardLinks = ({ currentDashboard, handleDashboardChange }) => (
  <React.Fragment>
    <Paper>
      <Tabs
        value={currentDashboard}
        onChange={handleDashboardChange}
      >
        <Tab label='Overview' />
        <Tab label='Social' />
        <Tab label='Resources' />
        <Tab />
        <Tab />
      </Tabs>
    </Paper>
  </React.Fragment>
);

GroupDashboardLinks.propTypes = {
  currentDashboard: PropTypes.number,
  handleDashboardChange: PropTypes.func
};

export default GroupDashboardLinks;
