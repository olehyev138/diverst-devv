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
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupPlan/BudgetItem/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

import { getAnnualBudgetBegin } from 'containers/Group/GroupPlan/AnnualBudget/actions';
import { selectAnnualBudget } from 'containers/Group/GroupPlan/AnnualBudget/selectors';
import annualReducer from 'containers/Group/GroupPlan/AnnualBudget/reducer';
import annualSaga from 'containers/Group/GroupPlan/AnnualBudget/saga';

const { form: formMessage } = messages;

export function BudgetCreatePage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });
  useInjectReducer({ key: 'annualBudgets', reducer: annualReducer });
  useInjectSaga({ key: 'annualBudgets', saga: annualSaga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');
  const annualBudgetId = rs.params('annual_budget_id');

  const links = {
    index: ROUTES.group.plan.budget.budgets.index.path(groupId, annualBudgetId)
  };

  useEffect(() => {
    console.log('Hi');
    props.getAnnualBudgetBegin({ id: annualBudgetId });
  }, []);

  return (
    <RequestForm
      budgetAction={props.createBudgetRequestBegin}
      isCommitting={props.isCommitting}
      buttonText={props.intl.formatMessage(formMessage.create)}
      annualBudget={props.annualBudget}
      currentGroup={props.currentGroup}
      links={links}
    />
  );
}

BudgetCreatePage.propTypes = {
  intl: intlShape.isRequired,
  createBudgetRequestBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func,
  currentGroup: PropTypes.object,
  isCommitting: PropTypes.bool,
  getAnnualBudgetBegin: PropTypes.func,
  annualBudget: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  currentGroup: selectGroup(),
  annualBudget: selectAnnualBudget(),
});

const mapDispatchToProps = {
  createBudgetRequestBegin,
  getAnnualBudgetBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  injectIntl,
)(Conditional(
  BudgetCreatePage,
  ['currentGroup.permissions.budgets_create?'],
  (props, rs) => ROUTES.group.plan.budget.index.path(rs.params('group_id')),
  permissionMessages.group.groupPlan.budget.createPage
));
