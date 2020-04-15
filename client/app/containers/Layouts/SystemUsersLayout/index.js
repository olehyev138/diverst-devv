import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { matchPath } from 'react-router';
import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import { ROUTES } from 'containers/Shared/Routes/constants';

import AdminLayout from '../AdminLayout';
import SystemUsersLinks from 'components/User/SystemUsersLinks';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { selectPermissions } from 'containers/Shared/App/selectors';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const SystemUsersPages = Object.freeze([
  'users',
  'roles',
  'import',
  'templates',
]);

const SystemUsersLayout = ({ component: Component, classes, ...rest }) => {
  const { permissions, location, computedMatch, defaultPage, ...other } = rest;

  let currentPage;
  if (matchPath(location.pathname, { path: ROUTES.admin.system.users.roles.index.path() }))
    currentPage = 'roles';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.users.import.path() }))
    currentPage = 'import';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.users.policy_templates.index.path() }))
    currentPage = 'templates';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.users.index.path() }))
    currentPage = 'users';

  const [tab, setTab] = useState(SystemUsersPages[currentPage]);

  useEffect(() => {
    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <AdminLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <SystemUsersLinks
            currentTab={tab}
            {...rest}
          />
          <Fade in appear>
            <div className={classes.content}>
              <Component {...other} />
            </div>
          </Fade>
        </React.Fragment>
      )}
    />
  );
};

SystemUsersLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  permissions: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
});

const withConnect = connect(
  mapStateToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(SystemUsersLayout);
