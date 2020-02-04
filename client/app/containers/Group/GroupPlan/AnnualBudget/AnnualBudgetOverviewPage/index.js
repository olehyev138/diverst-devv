import React, { memo, useEffect, useContext, useState } from 'react';
import dig from 'object-dig';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from '../saga';
import eventSaga from 'containers/Event/saga';
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
  selectInitiativesTotal,
  selectIsFetchingInitiatives
} from '../selectors';
import {
  getAnnualBudgetsBegin, annualBudgetsUnmount
} from '../actions';
import {
  getEventsBegin
} from 'containers/Event/actions';

import AnnualBudgetListItem from 'components/Group/GroupPlan/AnnualBudgetListItem';
import { ROUTES } from 'containers/Shared/Routes/constants';
import AnnualBudgetList from 'components/Group/GroupPlan/AnnualBudgetList';
import produce from 'immer';

const defaultParams = Object.freeze({
  count: 5,
  page: 0,
  order: 'desc',
  orderBy: 'id',
});

export function AnnualBudgetsPage(props) {
  useInjectReducer({ key: 'annualBudgets', reducer });
  useInjectSaga({ key: 'annualBudgets', saga });
  useInjectSaga({ key: 'events', saga: eventSaga });

  const rs = new RouteService(useContext);

  const groupId = dig(props, 'currentGroup', 'id') || rs.params('group_id');

  const [params, setParams] = useState(defaultParams);
  const [initParams, setInitParams] = useState({});

  useEffect(() => {
    props.getAnnualBudgetsBegin({ ...params, group_id: groupId });

    return () => props.annualBudgetsUnmount();
  }, []);

  const links = {
    budgetsIndex: id => ROUTES.group.plan.budget.budgets.index.path(groupId, id),
    newRequest: id => ROUTES.group.plan.budget.budgets.new.path(groupId, id),
    eventExpenses: id => ROUTES.group.plan.events.manage.expenses.index.path(groupId, id),
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

  const handleInitiativePagination = id => (payload) => {
    const newParams = {
      ...(initParams[id] || defaultParams),
      count: payload.count,
      page: payload.page
    };

    props.getEventsBegin({ ...newParams, query_scopes: [['of_annual_budget', id]], annualBudgetId: id });
    setParams(produce(initParams, (draft) => {
      draft[id] = newParams;
    }));
  };

  const handleInitiativeOrdering = id => (payload) => {
    const newParams = {
      ...(initParams[id] || defaultParams),
      orderBy: payload.orderBy,
      order: payload.orderDir
    };

    props.getEventsBegin({ ...newParams, query_scopes: [['of_annual_budget', id]], annualBudgetId: id });
    setParams(produce(initParams, (draft) => {
      draft[id] = newParams;
    }));
  };

  return (
    <React.Fragment>
      <AnnualBudgetList
        annualBudgets={props.annualBudgets}
        annualBudgetsTotal={props.annualBudgetsTotal}
        initiatives={props.initiatives}
        initiativesTotals={props.initiativesTotals}
        initiativesLoading={props.isFetchingInitiatives}
        group={props.currentGroup}
        links={links}
        isLoading={props.isFetchingAnnualBudgets}
        handlePagination={handlePagination}
        handleInitiativePagination={handleInitiativePagination}
        handleInitiativeOrdering={handleInitiativeOrdering}
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
  getEventsBegin: PropTypes.func,
  annualBudgetsUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFetchingAnnualBudgets: PropTypes.bool,
  isFetchingInitiatives: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  annualBudgets: selectPaginatedAnnualBudgets(),
  annualBudgetsTotal: selectAnnualBudgetsTotal(),
  initiatives: selectPaginatedInitiatives(),
  initiativesTotals: selectInitiativesTotal(),
  isFetchingAnnualBudgets: selectIsFetchingAnnualBudgets(),
  isFetchingInitiatives: selectIsFetchingInitiatives(),
});

const mapDispatchToProps = {
  getAnnualBudgetsBegin,
  getEventsBegin,
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
