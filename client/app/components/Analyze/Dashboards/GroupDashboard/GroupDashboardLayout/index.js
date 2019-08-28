/**
 *
 * GroupDashboardLayout
 */

import React from 'react';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import {
  Grid, Tabs, Tab, Paper
} from '@material-ui/core';

const GroupDashboardLayout = () => (
  <React.Fragment>
    <Paper>
      <Tabs>
        <Tab
          component={WrappedNavLink}
          label='Overview'
        />
        <Tab />
        <Tab />
      </Tabs>
    </Paper>
  </React.Fragment>
);

GroupDashboardLayout.propTypes = {
};

export default GroupDashboardLayout;
