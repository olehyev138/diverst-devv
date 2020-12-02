import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from '../saga';
import reducer from '../reducer';

import AnnualBudgetForm from 'components/Group/GroupPlan/AnnualBudgetForm';

import {
  selectGroupIsCommitting,
  selectGroup
} from 'containers/Group/selectors';

import { selectAnnualBudget, selectIsFetchingAnnualBudgets, selectPaginatedAnnualBudgets } from '../selectors';
import { updateAnnualBudgetBegin, getCurrentAnnualBudgetBegin, annualBudgetsUnmount, getChildBudgetsBegin } from '../actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function AnnualBudgetEditPage(props) {
  useInjectReducer({ key: 'annualBudgets', reducer });
  useInjectSaga({ key: 'annualBudgets', saga });

  const { group_id: groupId } = useParams();

  useEffect(() => {
    props.getChildBudgetsBegin({ groupId });

    return () => props.annualBudgetsUnmount();
  }, []);

  return (
    <AnnualBudgetForm
      annualBudgetAction={props.updateAnnualBudgetBegin}
      group={props.currentGroup}
      annualBudgets={props.childBudgets}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFetchingAnnualBudgets}
    />
  );
}

AnnualBudgetEditPage.propTypes = {
  currentGroup: PropTypes.object,
  childBudgets: PropTypes.array,
  updateAnnualBudgetBegin: PropTypes.func,
  getChildBudgetsBegin: PropTypes.func,
  annualBudgetsUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFetchingAnnualBudgets: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentAnnualBudget: selectAnnualBudget(),
  childBudgets: selectPaginatedAnnualBudgets(),
  isFetchingAnnualBudgets: selectIsFetchingAnnualBudgets(),
  isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  updateAnnualBudgetBegin,
  getCurrentAnnualBudgetBegin,
  getChildBudgetsBegin,
  annualBudgetsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  AnnualBudgetEditPage,
  ['currentGroup.permissions.annual_budgets_manage?'],
  (props, params) => ROUTES.group.plan.budget.index.path(params.group_id),
  permissionMessages.group.groupPlan.annualBudget.editPage
));
