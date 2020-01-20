/**
 *
 * AdminGroupListPage
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

import GroupList from 'components/Group/AdminGroupList';

export function AdminGroupListPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

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
    <React.Fragment>
      <GroupList
        isLoading={props.isLoading}
        groups={props.groups}
        groupTotal={props.groupTotal}
        defaultParams={params}
        deleteGroupBegin={props.deleteGroupBegin}
        handlePagination={handlePagination}
      />
    </React.Fragment>
  );
}

AdminGroupListPage.propTypes = {
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
)(AdminGroupListPage);
