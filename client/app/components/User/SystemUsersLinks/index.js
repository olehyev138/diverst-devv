import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function SystemUsersLinks(props) {
  const { classes } = props;
  const { currentTab } = props;

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.users.index.path()}
            label='Users'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.users.roles.index.path()}
            label='User Roles'
          />
          <Tab
            component={WrappedNavLink}
            to='#'
            label='Policy Templates'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.users.import.path()}
            label='Import Users'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

SystemUsersLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.number,
  currentGroup: PropTypes.object
};

export const StyledGroupManageLinks = withStyles(styles)(SystemUsersLinks);

export default compose(
  withStyles(styles),
  memo,
)(SystemUsersLinks);
