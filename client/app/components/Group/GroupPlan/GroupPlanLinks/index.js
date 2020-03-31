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
import { permission } from 'utils/permissionsHelpers';
import WithPermission from 'components/Compositions/WithPermission';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function GroupPlanLinks(props) {
  const { classes, currentGroup, currentTab } = props;

  const PermissionTabs = WithPermission(Tab);

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <PermissionTabs
            component={WrappedNavLink}
            to={ROUTES.group.plan.events.index.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.event} />}
            value='events'
            show={permission(props.currentGroup, 'events_manage?')}
          />
          <PermissionTabs
            component={WrappedNavLink}
            to={ROUTES.group.plan.kpi.updates.index.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.KPI} />}
            value='kpi'
            show={permission(props.currentGroup, 'kpi_manage?')}
          />
          <PermissionTabs
            component={WrappedNavLink}
            to={ROUTES.group.plan.budget.index.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.budgeting} />}
            value='budgeting'
            show={
              permission(props.currentGroup, 'annual_budgets_view?')
                || permission(props.currentGroup, 'budgets_create?')
                || permission(props.currentGroup, 'annual_budgets_index?')}
          />
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
