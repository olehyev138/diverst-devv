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
  const { currentTab, currentGroup } = props;

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={currentTab}
          indicatorColor='primary'
          textColor='primary'
        >
          { permission(currentGroup, 'annual_budgets_view?') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.plan.budget.overview.path(currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.overview} />}
              value='overview'
            />
          ) }
          { permission(currentGroup, 'annual_budgets_manage?') && (
            <Tab
              component={WrappedNavLink}
              to={ROUTES.group.plan.budget.editAnnualBudget.path(currentGroup.id)}
              label={<DiverstFormattedMessage {...messages.links.editAnnualBudget} />}
              value='annual_budget'
            />
          ) }
        </ResponsiveTabs>
      </Paper>
    </React.Fragment>
  );
}

BudgetLinks.propTypes = {
  classes: PropTypes.object,
  currentTab: PropTypes.string,
  currentGroup: PropTypes.object,
  groupId: PropTypes.number,
};

export const StyledGroupManageLinks = withStyles(styles)(BudgetLinks);

export default compose(
  withStyles(styles),
  memo,
)(BudgetLinks);
