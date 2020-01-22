/**
 *
 * AdminAnnualBudgetPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal, selectGroupIsLoading } from 'containers/Group/selectors';

import saga from 'containers/Group/saga';
import reducer from 'containers/Group/reducer';

import { getAnnualBudgetsBegin, groupListUnmount } from 'containers/Group/actions';

import AnnualBudgetList from 'components/Group/GroupPlan/AnnualBudgetList';

export function AdminAnnualBudgetPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const [params, setParams] = useState({ count: 10, page: 0, order: 'asc' });

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getAnnualBudgetsBegin(newParams);
    setParams(newParams);
  };


  useEffect(() => {
    props.getAnnualBudgetsBegin(params);

    return () => props.groupListUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getAnnualBudgetsBegin(newParams);
    setParams(newParams);
  };

  return (
    <AnnualBudgetList
      isLoading={props.isLoading}
      annualBudgets={props.groups}
      annualBudgetTotal={props.groupTotal}
      defaultParams={params}
      handlePagination={handlePagination}
      handleOrdering={handleOrdering}
    />
  );
}

AdminAnnualBudgetPage.propTypes = {
  getAnnualBudgetsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  groups: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectGroupIsLoading(),
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
});

const mapDispatchToProps = {
  getAnnualBudgetsBegin,
  groupListUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(AdminAnnualBudgetPage);
