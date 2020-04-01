import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { Tab, Paper } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
import { permission } from 'utils/permissionsHelpers';
import WithPermission from 'components/Compositions/WithPermission';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function BudgetLinks(props) {
  const { currentTab } = props;

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
            to={ROUTES.group.plan.budget.overview.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.overview} />}
            show={permission(props.currentGroup, 'annual_budgets_view?')}
            value='overview'
          />
          <PermissionTabs
            component={WrappedNavLink}
            to={ROUTES.group.plan.budget.editAnnualBudget.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.editAnnualBudget} />}
            show={permission(props.currentGroup, 'annual_budgets_manage?')}
            value='annual_budget'
          />
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

BudgetLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
  currentGroup: PropTypes.object,
};

export const StyledGroupManageLinks = withStyles(styles)(BudgetLinks);

export default compose(
  withStyles(styles),
  memo,
)(BudgetLinks);
