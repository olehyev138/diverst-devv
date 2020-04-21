import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import GroupManageLinks from 'components/Group/GroupManage/GroupManageLinks';
import GroupLayout from 'containers/Layouts/GroupLayout';
import { permission } from 'utils/permissionsHelpers';
import { push } from 'connected-react-router';
import RouteService from 'utils/routeHelpers';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const ManagePages = Object.freeze([
  'settings',
  'leaders',
  'sponsors'
]);

const redirectAction = path => push(path);

const GroupManageLayout = ({ component: Component, classes, defaultPage, ...rest }) => {
  const { currentGroup, location, computedMatch, redirectAction, showSnackbar, ...other } = rest;

  /* Get last element of current path, ie: '/group/:id/manage/settings -> settings */
  const currentPage = ManagePages.find(page => location.pathname.includes(page));

  const [tab, setTab] = useState(currentPage);

  useEffect(() => {
    if (defaultPage) {
      const rs = new RouteService({ computedMatch, location });

      if (permission(rest.currentGroup, 'update?'))
        redirectAction(ROUTES.group.manage.settings.index.path(rs.params('group_id')));
      else if (permission(rest.currentGroup, 'leaders_view?'))
        redirectAction(ROUTES.group.manage.leaders.index.path(rs.params('group_id')));
      else {
        showSnackbar({ message: 'You do not have permission to manage this group', options: { variant: 'warning' } });
        redirectAction(ROUTES.group.home.path(rs.params('group_id')));
      }
    }

    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <React.Fragment>
      <GroupLayout
        {...rest}
        component={matchProps => (
          <React.Fragment>
            <GroupManageLinks
              currentTab={tab}
              {...rest}
              {...matchProps}
            />
            <Fade in appear>
              <div className={classes.content}>
                {Component ? <Component {...rest} {...matchProps} /> : <React.Fragment />}
              </div>
            </Fade>
          </React.Fragment>
        )}
      />
    </React.Fragment>
  );
};

GroupManageLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  defaultPage: PropTypes.bool,
  currentGroup: PropTypes.object,
};

const mapDispatchToProps = {
  redirectAction,
  showSnackbar,
};

const withConnect = connect(
  createStructuredSelector({}),
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(GroupManageLayout);
