/**
 *
 * GroupDashboardLinks
 */

import React from 'react';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';

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
        <Tab label={<DiverstFormattedMessage {...messages.tabs.overview} />} />
        <Tab label={<DiverstFormattedMessage {...messages.tabs.social} />} />
        <Tab label={<DiverstFormattedMessage {...messages.tabs.resources} />} />
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
