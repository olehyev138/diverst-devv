import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupPlan/KPI/messages';

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
            label={<DiverstFormattedMessage {...messages.links.event} />}
            value='events'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.kpi.updates.index.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.KPI} />}
            value='kpi'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.index.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.budgeting} />}
            value='budgeting'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

GroupPlanLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
  currentGroup: PropTypes.object
};

export const StyledGroupPlanLinks = withStyles(styles)(GroupPlanLinks);

export default compose(
  withStyles(styles),
  memo,
)(GroupPlanLinks);
