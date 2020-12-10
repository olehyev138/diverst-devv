import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/GlobalSettings/messages';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function GlobalSettingsLinks(props) {
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
          { permission(props, 'enterprise_manage') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.globalSettings.enterpriseConfiguration.index.path()}
              label={<DiverstFormattedMessage {...messages.configuration} />}
              value='configuration'
            />
          )}
          { permission(props, 'fields_manage') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.globalSettings.fields.index.path()}
              label={<DiverstFormattedMessage {...messages.fields} />}
              value='fields'
            />
          )}
          { permission(props, 'custom_text_manage') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.globalSettings.customText.edit.path()}
              label={<DiverstFormattedMessage {...messages.customTexts} />}
              value='custom_texts'
            />
          )}
          { permission(props, 'sso_authentication') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.globalSettings.ssoSettings.edit.path()}
              label={<DiverstFormattedMessage {...messages.sso} />}
              value='sso'
            />
          )}
          { permission(props, 'emails_manage') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.admin.system.globalSettings.emails.layouts.index.path()}
              label={<DiverstFormattedMessage {...messages.emails} />}
              value='email'
            />
          )}
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

GlobalSettingsLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
};

export const StyledGroupManageLinks = withStyles(styles)(GlobalSettingsLinks);

export default compose(
  withStyles(styles),
  memo,
)(GlobalSettingsLinks);
