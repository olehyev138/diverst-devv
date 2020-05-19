/**
 *
 * UserGroupListPage
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
import { getGroupsBegin, groupListUnmount, deleteGroupBegin } from 'containers/Group/actions';
import reducer from 'containers/Group/reducer';

import saga from 'containers/Group/saga';

import GroupList from 'components/Group/UserGroupList';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function UserGroupListPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const [params, setParams] = useState({ count: 5, page: 0, orderBy: 'position', order: 'asc', query_scopes: ['all_parents'] });

  useEffect(() => {
    props.getGroupsBegin(params);

    return () => props.groupListUnmount();
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupsBegin(newParams);
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

UserGroupListPage.propTypes = {
  getGroupsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  isLoading: PropTypes.bool,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
  isLoading: selectGroupIsLoading(),
  permissions: selectPermissions(),
});

function mapDispatchToProps(dispatch) {
  return {
    getGroupsBegin: payload => dispatch(getGroupsBegin(payload)),
    groupListUnmount: () => dispatch(groupListUnmount()),
    deleteGroupBegin: payload => dispatch(deleteGroupBegin(payload))
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  UserGroupListPage,
  ['permissions.groups_view'],
  (props, rs) => ROUTES.user.home.path(),
  permissionMessages.group.userListPage
));
