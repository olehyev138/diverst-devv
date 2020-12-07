/**
 *
 * AdminAnnualBudgetPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { resetAnnualBudgetBegin } from 'containers/Group/GroupPlan/AnnualBudget/actions';

import BudgetInitializationForm from 'components/Group/GroupPlan/BudgetInitializationForm';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions, selectBudgetPeriod, selectEnterprise } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
import annualBudgetReducer from 'containers/Group/GroupPlan/AnnualBudget/reducer';
import annualBudgetSaga from 'containers/Group/GroupPlan/AnnualBudget/saga';

export function AdminInitializeBudgetPage(props) {
  useInjectReducer({ key: 'annualBudgets', reducer: annualBudgetReducer });
  useInjectSaga({ key: 'annualBudgets', saga: annualBudgetSaga });

  return (
    <BudgetInitializationForm
      resetAll={props.resetAnnualBudgetBegin}
      handleVisitEditPage={props.handleVisitEditPage}
      permissions={props.permissions}
      budgetPeriod={props.budgetPeriod}
    />
  );
}

AdminInitializeBudgetPage.propTypes = {
  handleVisitEditPage: PropTypes.func.isRequired,
  resetAnnualBudgetBegin: PropTypes.func.isRequired,
  permissions: PropTypes.object,
  budgetPeriod: PropTypes.array,
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
  permissions: selectPermissions(),
  budgetPeriod: selectBudgetPeriod(),
});

const mapDispatchToProps = {
  resetAnnualBudgetBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  AdminInitializeBudgetPage,
  ['permissions.manage_all_budgets', 'enterprise.plan_module_enabled'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.group.groupPlan.annualBudget.adminPlanPage,
  false,
  permissions => permissions.every(a => a)
));
