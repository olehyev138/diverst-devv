import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Box from '@material-ui/core/Box';
import Fade from '@material-ui/core/Fade';

import GroupPlanLayout from '..';
import BudgetLinks from 'components/Group/GroupPlan/BudgetLinks';
import RouteService from 'utils/routeHelpers';
import { permission } from 'utils/permissionsHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { push } from 'connected-react-router';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';

const styles = theme => ({});

const BudgetPages = Object.freeze([
  'overview',
  'annual_budget',
]);

const redirectAction = path => push(path);

const BudgetLayout = ({ component: Component, ...rest }) => {
  const { classes, data, location, computedMatch, redirectAction, showSnackbar, defaultPage, ...other } = rest;

  /* Get get first key that is in the path, ie: '/admin/system/settings/budgets/1/edit/ -> budgets */
  const currentPage = BudgetPages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage);

  useEffect(() => {
    if (defaultPage) {
      const rs = new RouteService({ computedMatch, location });

      if (permission(rest.currentGroup, 'annual_budgets_view?'))
        redirectAction(ROUTES.group.plan.budget.overview.path(rs.params('group_id')));
      else if (permission(rest.currentGroup, 'annual_budgets_manage?'))
        redirectAction(ROUTES.group.plan.budget.editAnnualBudget.path(rs.params('group_id')));
      else {
        showSnackbar({ message: 'You do not have permission to manage this group\'s budget', options: { variant: 'warning' } });
        redirectAction(ROUTES.group.plan.index.path(rs.params('group_id')));
      }
    }

    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  return (
    <GroupPlanLayout
      {...rest}
      component={matchProps => (
        <React.Fragment>
          <BudgetLinks
            currentTab={tab}
            {...matchProps}
          />
          <Box mb={3} />
          <Fade in appear>
            <div>
              {Component ? <Component {...other} /> : <React.Fragment />}
            </div>
          </Fade>
        </React.Fragment>
      )}
    />
  );
};

BudgetLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
  defaultPage: PropTypes.bool,
  computedMatch: PropTypes.object,
  currentGroup: PropTypes.object,
};

const mapDispatchToProps = {
  redirectAction,
  showSnackbar,
};

const withConnect = connect(
  createStructuredSelector({}),
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(BudgetLayout);
