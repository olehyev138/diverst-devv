import React, { memo, useContext, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupPlan/Budget/reducer';
import saga from 'containers/Group/GroupPlan/Budget/saga';

import { createBudgetRequestBegin } from 'containers/Group/GroupPlan/Budget/actions';
import { selectGroup } from 'containers/Group/selectors';
import { selectIsCommitting } from 'containers/Group/GroupPlan/Budget/selectors';

import RequestForm from 'components/Group/GroupPlan/BudgetRequestForm';
import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

export function BudgetCreatePage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });

  useEffect(() => () => {}, []);

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');
  const annualBudgetId = rs.params('annual_budget_id');

  const links = {
    index: ROUTES.group.plan.budget.budgets.index.path(groupId, annualBudgetId)
  };

  return (
    <RequestForm
      budgetAction={props.createBudgetRequestBegin}
      isCommitting={props.isCommitting}
      buttonText='Create'
      annualBudgetId={parseInt(annualBudgetId, 10)}
      currentGroup={props.currentGroup}
      links={links}
    />
  );
}

BudgetCreatePage.propTypes = {
  createBudgetRequestBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  currentGroup: selectGroup(),
});

const mapDispatchToProps = {
  createBudgetRequestBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(BudgetCreatePage);
