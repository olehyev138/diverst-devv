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
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.budget.overview.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.overview} />}
            value='overview'
          />
          <Tab
            component={WrappedNavLink}
            to={ROUTES.group.plan.budget.editAnnualBudget.path(props.currentGroup.id)}
            label={<DiverstFormattedMessage {...messages.links.editAnnualBudget} />}
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
  permission: PropTypes.func,
};

export const StyledGroupManageLinks = withStyles(styles)(BudgetLinks);

export default compose(
  withStyles(styles),
  memo,
)(BudgetLinks);
