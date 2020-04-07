import React, { memo, useEffect, useContext } from 'react';
import dig from 'object-dig';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from '../saga';
import reducer from '../reducer';

import RouteService from 'utils/routeHelpers';
import AnnualBudgetForm from 'components/Group/GroupPlan/AnnualBudgetForm';

import {
  selectGroupIsCommitting,
  selectGroup
} from 'containers/Group/selectors';
import {
  selectAnnualBudget, selectIsFetchingAnnualBudget
} from '../selectors';
import {
  updateAnnualBudgetBegin, getCurrentAnnualBudgetBegin, annualBudgetsUnmount
} from '../actions';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Conditional from 'components/Compositions/Conditional';

export function AnnualBudgetEditPage(props) {
  useInjectReducer({ key: 'annualBudgets', reducer });
  useInjectSaga({ key: 'annualBudgets', saga });

  const rs = new RouteService(useContext);

  useEffect(() => {
    const groupId = dig(props, 'currentGroup', 'id') || rs.params('group_id');
    props.getCurrentAnnualBudgetBegin({ groupId });

    return () => props.annualBudgetsUnmount();
  }, []);

  return (
    <AnnualBudgetForm
      annualBudgetAction={props.updateAnnualBudgetBegin}
      group={props.currentGroup}
      annualBudget={props.currentAnnualBudget}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFetchingAnnualBudget}
    />
  );
}

AnnualBudgetEditPage.propTypes = {
  currentGroup: PropTypes.object,
  currentAnnualBudget: PropTypes.object,
  updateAnnualBudgetBegin: PropTypes.func,
  getCurrentAnnualBudgetBegin: PropTypes.func,
  annualBudgetsUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFetchingAnnualBudget: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentAnnualBudget: selectAnnualBudget(),
  isFetchingAnnualBudget: selectIsFetchingAnnualBudget(),
  isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  updateAnnualBudgetBegin,
  getCurrentAnnualBudgetBegin,
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
  (props, rs) => ROUTES.group.plan.budget.index.path(rs.params('group_id')),
  'group.groupPlan.annualBudget.editPage'
));
