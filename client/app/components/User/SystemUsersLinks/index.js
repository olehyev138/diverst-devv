import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

import messages from 'containers/User/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

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
            label={<DiverstFormattedMessage {...messages.tab.users} />}
            value='users'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.users.roles.index.path()}
            label={<DiverstFormattedMessage {...messages.tab.roles} />}
            value='roles'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.users.policy_templates.index.path()}
            label={<DiverstFormattedMessage {...messages.tab.policy} />}
            value='templates'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.users.import.path()}
            label='Import Users'
            value='import'
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
