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
import { selectGroupIsCommitting } from 'containers/Group/selectors';

import RequestForm from 'components/Group/GroupPlan/BudgetRequestForm';
import RouteService from 'utils/routeHelpers';

export function GroupCreatePage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });

  useEffect(() => () => {}, []);

  const rs = new RouteService(useContext);
  const annualBudgetId = rs.params('annual_budget_id');

  return (
    <RequestForm
      budgetAction={props.createBudgetRequestBegin}
      isCommitting={props.isCommitting}
      buttonText='Create'
      annualBudgetId={annualBudgetId}
    />
  );
}

GroupCreatePage.propTypes = {
  createBudgetRequestBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func,
  groups: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectGroupIsCommitting(),
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
)(GroupCreatePage);
