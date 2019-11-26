import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

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
            label='Theme'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.branding.home.path()}
            label='Home'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.branding.sponsors.path()}
            label='Sponsors'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

BrandingLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.number,
  currentGroup: PropTypes.object
};

export const StyledGroupManageLinks = withStyles(styles)(BrandingLinks);

export default compose(
  withStyles(styles),
  memo,
)(BrandingLinks);
