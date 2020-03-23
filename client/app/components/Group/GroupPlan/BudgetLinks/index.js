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
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({});

/* eslint-disable react/no-multi-comp */
export function BudgetLinks(props) {
  const { currentTab } = props;

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Permission show={permission(props.currentGroup, 'annual_budgets_view?')} value='overview'>
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.plan.budget.overview.path(props.currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.overview} />}
            />
          </Permission>
          <Permission show={permission(props.currentGroup, 'annual_budgets_manage?')} value='annual_budget'>
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.plan.budget.editAnnualBudget.path(props.currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.editAnnualBudget} />}
            />
          </Permission>
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
