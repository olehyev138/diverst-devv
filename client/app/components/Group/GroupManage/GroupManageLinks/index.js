import React, { useState } from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import PropTypes from 'prop-types';

import { FormattedMessage } from 'react-intl';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import {
  AppBar, Toolbar, Button, Hidden, Menu, MenuItem, ListItemIcon, IconButton,
  Tab, Tabs
} from '@material-ui/core';
import { matchPath } from 'react-router';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({
});

/* eslint-disable react/no-multi-comp */
export function GroupManageLinks(props) {
  const { classes } = props;
  const { currentTab } = props;

  return (
    <React.Fragment>
      <Tabs
        value={currentTab}
      >
        <Tab
          component={WrappedNavLink}
          to={ROUTES.group.manage.settings.index.path(props.currentGroup.id)}
          label='Settings'
        />
        <Tab
          component={WrappedNavLink}
          to={ROUTES.group.manage.leaders.index.path(props.currentGroup.id)}
          label='Leaders'
        />
      </Tabs>
    </React.Fragment>
  );
}

GroupManageLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.number,
  currentGroup: PropTypes.object
};

const mapStateToProps = createStructuredSelector({});

const mapDispatchToProps = {
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

export const StyledGroupManageLinks = withStyles(styles)(GroupManageLinks);

export default compose(
  withConnect,
  withStyles(styles),
)(GroupManageLinks);
