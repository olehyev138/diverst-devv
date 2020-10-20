import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useLocation } from 'react-router-dom';

import { matchPath } from 'react-router';
import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import { ROUTES } from 'containers/Shared/Routes/constants';

import SystemUsersLinks from 'components/User/SystemUsersLinks';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { selectPermissions } from 'containers/Shared/App/selectors';
import { renderChildrenWithProps } from 'utils/componentHelpers';
import { push } from 'connected-react-router';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const SystemUsersPages = Object.freeze([
  'users',
  'roles',
  'templates',
  'import',
]);

const redirectAction = path => push(path);

const SystemUsersLayout = (props) => {
  const { classes, children, permissions, showSnackbar, redirectAction, ...rest } = props;

  const location = useLocation();

  let currentPage;
  if (matchPath(location.pathname, { path: ROUTES.admin.system.users.roles.index.path() }))
    currentPage = 'roles';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.users.import.path() }))
    currentPage = 'import';
  else if (matchPath(location.pathname, { path: ROUTES.admin.system.users.policy_templates.index.path() }))
    currentPage = 'templates';
  else if (!matchPath(location.pathname, { path: ROUTES.admin.system.users.index.path(), exact: true }))
    currentPage = 'users';

  const defaultTab = (() => {
    if (permission(props, 'users_create'))
      return SystemUsersPages[0];
    if (permission(props, 'policy_templates_view'))
      return SystemUsersPages[1];
    if (permission(props, 'policy_templates_manage'))
      return SystemUsersPages[2];
    if (permission(props, 'users_create'))
      return SystemUsersPages[3];
    return null;
  });

  const [tab, setTab] = useState(SystemUsersPages[currentPage] || defaultTab);

  useEffect(() => {
    if (matchPath(location.pathname, { path: ROUTES.admin.system.users.index.path(), exact: true }))
      if (permission(props, 'users_create'))
        redirectAction(ROUTES.admin.system.users.list.path());
      else if (permission(props, 'policy_templates_view'))
        redirectAction(ROUTES.admin.system.users.roles.index.path());
      else if (permission(props, 'policy_templates_create'))
        redirectAction(ROUTES.admin.system.users.roles.index.path());
      else if (permission(props, 'policy_templates_manage'))
        redirectAction(ROUTES.admin.system.users.roles.index.path());
      else {
        showSnackbar({ message: 'You do not have permission to see this page', options: { variant: 'warning' } });
        redirectAction(ROUTES.user.home.path());
      }

    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <React.Fragment>
      <SystemUsersLinks
        currentTab={tab}
        permissions={permissions}
        {...rest}
      />
      <Fade in appear>
        <div className={classes.content}>
          {renderChildrenWithProps(children, { ...rest })}
        </div>
      </Fade>
    </React.Fragment>
  );
};

SystemUsersLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  permissions: PropTypes.object,
  redirectAction: PropTypes.func,
  showSnackbar: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  redirectAction,
  showSnackbar,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(SystemUsersLayout);
