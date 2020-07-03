import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { useLocation, useRouteMatch } from 'react-router-dom';

import { withStyles } from '@material-ui/core/styles';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import GlobalSettingsLinks from 'components/GlobalSettings/GlobalSettingsLinks';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { selectPermissions } from 'containers/Shared/App/selectors';
import { push } from 'connected-react-router';
import { permission } from 'utils/permissionsHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { renderChildrenWithProps } from 'utils/componentHelpers';

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

const GlobalSettingsLayout = (props) => {
  const { classes, children, permissions, redirectAction, showSnackbar, ...rest } = props;

  const location = useLocation();
  const isRoot = !!useRouteMatch({ path: ROUTES.admin.system.globalSettings.pathPrefix, exact: true });

  /* Get get first key that is in the path, ie: '/admin/system/settings/emails/1/edit/ -> emails */
  const currentPage = GlobalSettingsPages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage || GlobalSettingsPages[0]);

  useEffect(() => {
    if (isRoot)
      if (permission(props, 'enterprise_manage'))
        redirectAction(ROUTES.admin.system.globalSettings.enterpriseConfiguration.index.path());
      else if (permission(props, 'fields_manage'))
        redirectAction(ROUTES.admin.system.globalSettings.fields.index.path());
      else if (permission(props, 'custom_text_manage'))
        redirectAction(ROUTES.admin.system.globalSettings.customText.index.path());
      else if (permission(props, 'sso_authentication'))
        redirectAction(ROUTES.admin.system.globalSettings.ssoSettings.index.path());
      else if (permission(props, 'emails_manage'))
        redirectAction(ROUTES.admin.system.globalSettings.emails.layouts.index.path());
      else if (permissions) {
        showSnackbar({ message: 'You do not have permission to manage global settings', options: { variant: 'warning' } });
        redirectAction(permission(props, 'adminPath') || ROUTES.user.home.path());
      }

    if (tab !== currentPage && currentPage)
      setTab(currentPage);
  }, [currentPage, permissions]);

  return (
    <React.Fragment>
      <GlobalSettingsLinks
        currentTab={tab}
      />
      <Box mb={3} />
      <Fade in appear>
        <div>
          {renderChildrenWithProps(children, { ...rest })}
        </div>
      </Fade>
    </React.Fragment>
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
  children: PropTypes.any,
  permissions: PropTypes.object,
  location: PropTypes.object,
  redirectAction: PropTypes.func,
  showSnackbar: PropTypes.func,
};

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(GlobalSettingsLayout);
