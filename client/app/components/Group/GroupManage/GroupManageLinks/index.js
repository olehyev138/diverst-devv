import React, { memo, useState } from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import { createStructuredSelector } from 'reselect';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import {
  AppBar, Toolbar, Button, Hidden, Menu, MenuItem, ListItemIcon, IconButton,
  Tab, Paper
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

const styles = theme => ({
});

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
            label='Settings'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.manage.leaders.index.path(props.currentGroup.id)}
            label='Leaders'
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
  memo,
)(GroupManageLinks);
