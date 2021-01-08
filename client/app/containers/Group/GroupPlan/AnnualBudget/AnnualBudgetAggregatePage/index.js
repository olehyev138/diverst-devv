import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import produce from 'immer';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from '../saga';
import eventSaga from 'containers/Event/saga';
import reducer from '../reducer';

import { selectGroup } from 'containers/Group/selectors';
import {
  selectPaginatedAnnualBudgets,
  selectIsFetchingAnnualBudgets,
  selectAnnualBudgetsTotal,
  selectPaginatedInitiatives,
  selectInitiativesTotal,
  selectIsFetchingInitiatives
} from '../selectors';

import { getAggregateBudgetsBegin, annualBudgetsUnmount } from '../actions';
import { getEventsBegin } from 'containers/Event/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import AnnualBudgetList from 'components/Group/GroupPlan/AnnualBudgetList';
import Conditional from 'components/Compositions/Conditional';

import permissionMessages from 'containers/Shared/Permissions/messages';

const defaultParams = Object.freeze({
  count: 5,
  page: 0,
  order: 'desc',
  orderBy: 'id',
});

const defaultInitiativeParams = Object.freeze({
  count: 5,
  page: 0,
  order: 'desc',
  orderBy: '`initiatives`.`id`',
});

export function AnnualBudgetsAggregatePage(props) {
  useInjectReducer({ key: 'annualBudgets', reducer });
  useInjectSaga({ key: 'annualBudgets', saga });
  useInjectSaga({ key: 'events', saga: eventSaga });

  const { group_id: groupId } = useParams();

  const [params, setParams] = useState(defaultParams);
  const [initParams, setInitParams] = useState({});

  useEffect(() => {
    props.getAggregateBudgetsBegin({ ...params, groupId });

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

    props.getAggregateBudgetsBegin({ ...newParams, group_id: groupId });
    setParams(newParams);
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
        defaultParams={defaultParams}
        currentGroup={props.currentGroup}
        type='aggregate'
      />
    </React.Fragment>
  );
}

AnnualBudgetsAggregatePage.propTypes = {
  currentGroup: PropTypes.object,
  annualBudgets: PropTypes.array,
  annualBudgetsTotal: PropTypes.number,
  initiatives: PropTypes.object,
  initiativesTotals: PropTypes.object,
  getAggregateBudgetsBegin: PropTypes.func,
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
  getAggregateBudgetsBegin,
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
)(Conditional(
  AnnualBudgetsAggregatePage,
  ['currentGroup.permissions.annual_budgets_view?'],
  (props, params) => ROUTES.group.home.path(params.group_id),
  permissionMessages.group.groupPlan.annualBudget.overviewPage
));