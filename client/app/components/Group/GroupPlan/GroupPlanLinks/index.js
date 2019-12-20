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
export function GroupPlanLinks(props) {
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
            to={ROUTES.group.plan.events.index.path(props.currentGroup.id)}
            label='Event Management'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.kpi.metrics.path(props.currentGroup.id)}
            label='KPI'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.index.path(props.currentGroup.id)}
            label='Updates'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.index.path(props.currentGroup.id)}
            label='Budgeting'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

GroupPlanLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.oneOfType([
    PropTypes.number,
    PropTypes.bool,
  ]),
  currentGroup: PropTypes.object
};

export const StyledGroupPlanLinks = withStyles(styles)(GroupPlanLinks);

export default compose(
  withStyles(styles),
  memo,
)(GroupPlanLinks);
