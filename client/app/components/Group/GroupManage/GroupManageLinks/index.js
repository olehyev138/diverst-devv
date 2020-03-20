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
import Conditional from 'components/Compositions/Conditional';
import Permission from 'components/Shared/DiverstPermission';
import dig from 'object-dig';
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
          <Permission show={props.permission('update?')}>
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.manage.settings.index.path(props.currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.settings} />}
            />
          </Permission>
          <Permission show={props.permission('leaders_view?')}>
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.manage.leaders.index.path(props.currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.leaders} />}
            />
          </Permission>
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

GroupManageLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.number,
  currentGroup: PropTypes.object,
  permission: PropTypes.func,
};

export const StyledGroupManageLinks = withStyles(styles)(GroupManageLinks);

export default compose(
  withStyles(styles),
  memo,
)(GroupManageLinks);
