import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Branding/messages';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function BrandingLinks(props) {
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
            to={ROUTES.admin.system.branding.theme.path()}
            label={<DiverstFormattedMessage {...messages.tabs.theme} />}
            value='theme'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.branding.home.path()}
            label={<DiverstFormattedMessage {...messages.tabs.home} />}
            value='home'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.branding.sponsors.index.path()}
            label={<DiverstFormattedMessage {...messages.tabs.sponsors} />}
            value='sponsors'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

BrandingLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
  currentGroup: PropTypes.object
};

export const StyledGroupManageLinks = withStyles(styles)(BrandingLinks);

export default compose(
  withStyles(styles),
  memo,
)(BrandingLinks);
