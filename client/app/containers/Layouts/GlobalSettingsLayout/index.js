import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import AdminLayout from '../AdminLayout';
import GlobalSettingsLinks from 'components/GlobalSettings/GlobalSettingsLinks';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { selectPermissions } from 'containers/Shared/App/selectors';
import { push } from 'connected-react-router';
import { permission } from 'utils/permissionsHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({});

const redirectAction = path => push(path);

const GlobalSettingsPages = Object.freeze([
  'fields',
  'custom_texts',
  'configuration',
  'sso',
  'email',
  'policy_templates',
]);

const GlobalSettingsLayout = ({ component: Component, ...rest }) => {
  const { classes, data, defaultPage, permissions, computedMatch, location, redirectAction, showSnackbar, ...other } = rest;

  /* Get get first key that is in the path, ie: '/admin/system/settings/emails/1/edit/ -> emails */
  const currentPage = GlobalSettingsPages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage);

  useEffect(() => {
    if (!Component) {
      if (permission(rest, 'enterprise_manage'))
        redirectAction(ROUTES.admin.system.globalSettings.enterpriseConfiguration.index.path());
      else if (permission(rest, 'fields_manage'))
        redirectAction(ROUTES.admin.system.globalSettings.fields.index.path());
      else if (permission(rest, 'custom_text_manage'))
        redirectAction(ROUTES.admin.system.globalSettings.customText.index.path());
      else if (permission(rest, 'sso_authentication'))
        redirectAction(ROUTES.admin.system.globalSettings.ssoSettings.index.path());
      else if (permission(rest, 'emails_manage'))
        redirectAction(ROUTES.admin.system.globalSettings.emails.index.path());
      else if (permissions) {
        showSnackbar({ message: 'You do not have permission to manage global settings', options: { variant: 'warning' } });
        redirectAction(permission(rest, 'adminPath') || ROUTES.user.home.path());
      }
    }

    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage, permissions]);

  return (
    <AdminLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <GlobalSettingsLinks
            currentTab={tab}
            {...matchProps}
          />
          <Box mb={3} />
          <Fade in appear>
            <div>
              { Component ? <Component {...other} /> : <React.Fragment /> }
            </div>
          </Fade>
        </React.Fragment>
      )}
    />
  );
};

const mapDispatchToProps = {
  redirectAction,
  showSnackbar,
};

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

GlobalSettingsLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
};

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(GlobalSettingsLayout);
