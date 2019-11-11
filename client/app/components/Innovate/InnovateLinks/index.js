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
export function InnovateLinks(props) {
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
            to='#'
            label='Campaigns'
          />
          <Tab
            component={WrappedNavLink}
            to='#'
            label='Financials'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

InnovateLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.number,
  currentGroup: PropTypes.object
};

export default compose(
  withStyles(styles),
  memo,
)(InnovateLinks);
