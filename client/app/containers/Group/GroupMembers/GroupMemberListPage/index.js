import React, {
  memo, useEffect, useContext, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupMembers/reducer';
import saga from 'containers/Group/GroupMembers/saga';

import {
  getMembersBegin, deleteMemberBegin,
  groupMembersUnmount
} from 'containers/Group/GroupMembers/actions';
import {
  selectPaginatedMembers, selectMemberTotal,
  selectIsFetchingMembers
} from 'containers/Group/GroupMembers/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupMemberList from 'components/Group/GroupMembers/GroupMemberList';

const MemberTypes = Object.freeze([
  'active',
  'inactive',
  'pending',
  'accepted_users',
  'all',
]);

export function GroupMemberListPage(props) {
  useInjectReducer({ key: 'members', reducer });
  useInjectSaga({ key: 'members', saga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id')[0];

  const [memberType, setMemberType] = React.useState('accepted_users');
  const handleChangeTab = (type) => {
    setMemberType(type);
    if (MemberTypes.includes(type))
      handleMemberScopes([type], true);
  };

  const defaultParams = {
    group_id: groupId, count: 10, page: 0,
    orderBy: 'users.id', order: 'asc',
    query_scopes: ['active']
  };

  const [params, setParams] = useState(defaultParams);
  const links = {
    groupMembersNew: ROUTES.group.members.new.path(groupId),
  };

  const handleMemberScopes = (scopes, resetParams = false) => {
    if (resetParams)
      setParams(defaultParams);

    if (groupId) {
      const newParams = {
        ...params,
        group_id: groupId,
        query_scopes: scopes
      };
      props.getMembersBegin(newParams);
      setParams(newParams);
    }
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getMembersBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getMembersBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    props.getMembersBegin(params);

    return () => {
      props.groupMembersUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <GroupMemberList
        memberList={props.memberList}
        memberTotal={props.memberTotal}
        isFetchingMembers={props.isFetchingMembers}
        groupId={groupId}
        deleteMemberBegin={props.deleteMemberBegin}
        links={links}
        setParams={params}
        params={params}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}

        memberType={memberType}
        MemberTypes={MemberTypes}
        setMemberType={setMemberType}
        handleChangeTab={handleChangeTab}
      />
    </React.Fragment>
  );
}

GroupMemberListPage.propTypes = {
  getMembersBegin: PropTypes.func,
  deleteMemberBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool
};

const mapStateToProps = createStructuredSelector({
  memberList: selectPaginatedMembers(),
  memberTotal: selectMemberTotal(),
  isFetchingMembers: selectIsFetchingMembers()
});

const mapDispatchToProps = {
  getMembersBegin,
  deleteMemberBegin,
  groupMembersUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMemberListPage);
