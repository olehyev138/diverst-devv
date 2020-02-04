import React, {memo, useEffect, useContext, useState} from 'react';
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
  selectPaginatedAnnualBudgets,
  selectIsFetchingAnnualBudgets,
  selectAnnualBudgetsTotal,
  selectPaginatedInitiatives,
  selectInitiativesTotal
} from '../selectors';
import {
  getAnnualBudgetsBegin, annualBudgetsUnmount
} from '../actions';

import AnnualBudgetListItem from 'components/Group/GroupPlan/AnnualBudgetListItem';
import { ROUTES } from 'containers/Shared/Routes/constants';
import AnnualBudgetList from 'components/Group/GroupPlan/AnnualBudgetList';

const defaultParams = Object.freeze({
  count: 5,
  page: 0,
  order: 'desc',
  orderBy: 'id',
});

export function AnnualBudgetsPage(props) {
  useInjectReducer({ key: 'annualBudgets', reducer });
  useInjectSaga({ key: 'annualBudgets', saga });

  const rs = new RouteService(useContext);

  const groupId = dig(props, 'currentGroup', 'id') || rs.params('group_id');

  const [params, setParams] = useState(defaultParams);

  useEffect(() => {
    props.getAnnualBudgetsBegin({ ...params, group_id: groupId });

    return () => props.annualBudgetsUnmount();
  }, []);

  const links = {
    budgetsIndex: id => ROUTES.group.plan.budget.budgets.index.path(groupId, id),
    newRequest: id => ROUTES.group.plan.budget.budgets.new.path(groupId, id)
  };

  const handlePagination = (payload) => {
    const newParams = {
      ...params,
      count: payload.count,
      page: payload.page
    };

    props.getAnnualBudgetsBegin({ ...newParams, group_id: groupId });
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <AnnualBudgetList
        annualBudgets={props.annualBudgets}
        annualBudgetsTotal={props.annualBudgetsTotal}
        initiatives={{}}
        initiativesTotals={{}}
        group={props.currentGroup}
        links={links}
        isLoading={props.isFetchingAnnualBudgets}
        handlePagination={handlePagination}
        defaultParams={defaultParams}
      />
    </React.Fragment>
  );
}

AnnualBudgetsPage.propTypes = {
  currentGroup: PropTypes.object,
  annualBudgets: PropTypes.array,
  annualBudgetsTotal: PropTypes.number,
  initiatives: PropTypes.object,
  initiativesTotals: PropTypes.object,
  getAnnualBudgetsBegin: PropTypes.func,
  annualBudgetsUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFetchingAnnualBudgets: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  annualBudgets: selectPaginatedAnnualBudgets(),
  annualBudgetsTotal: selectAnnualBudgetsTotal(),
  initiatives: selectPaginatedInitiatives(),
  initiativesTotals: selectInitiativesTotal(),
  isFetchingAnnualBudgets: selectIsFetchingAnnualBudgets(),
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
