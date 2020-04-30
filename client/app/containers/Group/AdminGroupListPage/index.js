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

import { getGroupsBegin, groupListUnmount, deleteGroupBegin, updateGroupBegin } from 'containers/Group/actions';
import GroupList from 'components/Group/AdminGroupList';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { MetricsDashboardCreatePage } from 'containers/Analyze/Dashboards/MetricsDashboard/MetricsDashboardCreatePage';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function AdminGroupListPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc', query_scopes: ['all_parents'] });

  useEffect(() => {
    props.getGroupsBegin(params);

    return () => props.groupListUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupsBegin(newParams);
    setParams(newParams);
  };

  // Little bug around here
  return (
    <React.Fragment>
        <GroupList
        isLoading={props.isLoading}
        groups={props.groups}
        groupTotal={props.groupTotal}
        defaultParams={params}
        deleteGroupBegin={props.deleteGroupBegin}
        updateGroupBegin={props.updateGroupBegin}
        handlePagination={handlePagination}
      />
    </React.Fragment>
  );
}

AdminGroupListPage.propTypes = {
  getGroupsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  groups: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  updateGroupBegin: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  isLoading: selectGroupIsLoading(),
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getGroupsBegin,
  groupListUnmount,
  deleteGroupBegin,
  updateGroupBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  AdminGroupListPage,
  ['permissions.groups_create'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.group.adminListPage
));
