import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/GlobalSettings/Email/messages';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function EmailLinks(props) {
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
            to={ROUTES.admin.system.globalSettings.emails.layouts.index.path()}
            label={<DiverstFormattedMessage {...messages.layouts} />}
            value='layouts'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.admin.system.globalSettings.emails.events.index.path()}
            label={<DiverstFormattedMessage {...messages.events} />}
            value='events'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

EmailLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
  currentGroup: PropTypes.object,
};

export const StyledGroupManageLinks = withStyles(styles)(EmailLinks);

export default compose(
  withStyles(styles),
  memo,
)(EmailLinks);
