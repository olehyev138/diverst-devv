import React, { memo, useEffect, useContext } from 'react';
import dig from 'object-dig';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/saga';
import budgetSaga from '../saga';
import reducer from 'containers/Group/reducer';

import RouteService from 'utils/routeHelpers';
import AnnualBudgetForm from 'components/Group/GroupPlan/AnnualBudgetForm';

import {
  selectGroupIsCommitting,
  selectGroup
} from 'containers/Group/selectors';
import {
  updateAnnualBudgetBegin
} from '../actions';

export function GroupEditPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  useInjectSaga({ key: 'budgets', saga: budgetSaga });

  const rs = new RouteService(useContext);

  return (
    <AnnualBudgetForm
      annualBudgetAction={props.updateAnnualBudgetBegin}
      group={props.currentGroup}
      annualBudget={props.currentGroup.current_annual_budget}
      isCommitting={props.isCommitting}
    />
  );
}

GroupEditPage.propTypes = {
  currentGroup: PropTypes.object,
  updateAnnualBudgetBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  updateAnnualBudgetBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupEditPage);
