import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupManage/messages';

import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function GroupManageLinks(props) {
  const { classes, currentGroup, currentTab } = props;

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          { permission(currentGroup, 'update?') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.manage.settings.index.path(currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.settings} />}
              value='settings'
            />
          ) }
          { permission(currentGroup, 'leaders_view?') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.manage.leaders.index.path(currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.leaders} />}
              value='leaders'
            />
          ) }
          { permission(currentGroup, 'update?') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.manage.sponsors.index.path(currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.sponsors} />}
              value='sponsors'
            />
          ) }
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

GroupManageLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
  currentGroup: PropTypes.object,
};

export const StyledGroupManageLinks = withStyles(styles)(GroupManageLinks);

export default compose(
  withStyles(styles),
  memo,
)(GroupManageLinks);
