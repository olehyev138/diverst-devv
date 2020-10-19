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
import WithPermission from 'components/Compositions/WithPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function SystemUsersLinks(props) {
  const { classes } = props;
  const { currentTab } = props;

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={currentTab || 'users'}
          indicatorColor='primary'
          textColor='primary'
        >
          { permission(props, 'users_create') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.users.list.path()}
              label={<DiverstFormattedMessage {...messages.tab.users} />}
              value='users'
            />
          ) }
          { permission(props, 'policy_templates_view') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.users.roles.index.path()}
              label={<DiverstFormattedMessage {...messages.tab.roles} />}
              value='roles'
            />
          ) }
          { permission(props, 'policy_templates_manage') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.users.policy_templates.index.path()}
              label={<DiverstFormattedMessage {...messages.tab.policy} />}
              value='templates'
            />
          ) }
          { permission(props, 'users_create') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.users.import.path()}
              label='Import Users'
              value='import'
            />
          ) }
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

SystemUsersLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
  currentGroup: PropTypes.object
};

export const StyledGroupManageLinks = withStyles(styles)(SystemUsersLinks);

export default compose(
  withStyles(styles),
  memo,
)(SystemUsersLinks);
