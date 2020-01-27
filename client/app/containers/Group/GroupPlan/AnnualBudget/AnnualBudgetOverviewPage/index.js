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

import {
  selectGroupIsCommitting,
  selectGroup
} from 'containers/Group/selectors';
import {
  selectPaginatedAnnualBudgets, selectIsFetchingAnnualBudgets
} from '../selectors';
import {
  getAnnualBudgetsBegin, annualBudgetsUnmount
} from '../actions';

import AnnualBudgetListItem from 'components/Group/GroupPlan/AnnualBudgetListItem';
import { ROUTES } from 'containers/Shared/Routes/constants';

export function AnnualBudgetsPage(props) {
  useInjectReducer({ key: 'annualBudgets', reducer });
  useInjectSaga({ key: 'annualBudgets', saga });

  const rs = new RouteService(useContext);

  const groupId = dig(props, 'currentGroup', 'id') || rs.params('group_id');

  useEffect(() => {
    props.getAnnualBudgetsBegin({ group_id: groupId });

    return () => props.annualBudgetsUnmount();
  }, []);

  const links = {
    budgetsIndex: id => ROUTES.group.plan.budget.budgets.index.path(groupId, id),
    newRequest: id => ROUTES.group.plan.budget.budgets.new.path(groupId, id)
  };

  return (
    <React.Fragment>
      {props.annualBudgets.map(ab => (
        <AnnualBudgetListItem
          item={ab}
          links={links}
        />
      ))}
    </React.Fragment>
  );
}

AnnualBudgetsPage.propTypes = {
  currentGroup: PropTypes.object,
  annualBudgets: PropTypes.array,
  getAnnualBudgetsBegin: PropTypes.func,
  annualBudgetsUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFetchingAnnualBudget: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  annualBudgets: selectPaginatedAnnualBudgets(),
  isFetchingAnnualBudgets: selectIsFetchingAnnualBudgets(),
  isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  getAnnualBudgetsBegin,
  annualBudgetsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(AnnualBudgetsPage);
