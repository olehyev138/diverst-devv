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
const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function GroupManageLinks(props) {
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
            to={ROUTES.group.manage.settings.index.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.settings} />}
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.manage.leaders.index.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.leaders} />}
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

GroupManageLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.number,
  currentGroup: PropTypes.object
};

export const StyledGroupManageLinks = withStyles(styles)(GroupManageLinks);

export default compose(
  withStyles(styles),
  memo,
)(GroupManageLinks);
