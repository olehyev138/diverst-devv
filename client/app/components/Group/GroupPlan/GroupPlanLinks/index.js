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
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import dig from 'object-dig';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function GroupPlanLinks(props) {
  const { classes, currentGroup, currentTab } = props;

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Permission show={permission(props.currentGroup, 'events_manage?')} value='events'>
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.plan.events.index.path(props.currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.event} />}
            />
          </Permission>
          <Permission show={permission(props.currentGroup, 'kpi_manage?')} value='kpi'>
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.plan.kpi.updates.index.path(props.currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.KPI} />}
            />
          </Permission>
          <Permission
            show={
              permission(props.currentGroup, 'annual_budgets_view?')
              || permission(props.currentGroup, 'budgets_create?')
              || permission(props.currentGroup, 'annual_budgets_index?')}
            value='budgeting'
          >
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.plan.budget.overview.path(props.currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.budgeting} />}
            />
          </Permission>
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

GroupPlanLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
  currentGroup: PropTypes.object,
};

export const StyledGroupPlanLinks = withStyles(styles)(GroupPlanLinks);

export default compose(
  withStyles(styles),
  memo,
)(GroupPlanLinks);
