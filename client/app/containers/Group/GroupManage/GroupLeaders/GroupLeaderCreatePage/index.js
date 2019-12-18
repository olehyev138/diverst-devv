import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import useInjectSaga from 'utils/injectSaga';
import useInjectReducer from 'utils/injectReducer';
import reducer from 'containers/Group/GroupManage/GroupLeaders/reducer';
import saga from 'containers/Group/GroupManage/GroupLeaders/saga';
import userReducer from 'containers/User/reducer';
import userSaga from 'containers/User/saga';
import membersReducer from 'containers/Group/GroupMembers/reducer';
import memberSaga from 'containers/Group/GroupMembers/saga';

import { createGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';
import {
  selectGroupLeaderTotal, selectIsCommitting
} from 'containers/Group/GroupManage/GroupLeaders/selectors';
import { getUsersBegin } from 'containers/User/actions';
import { selectPaginatedSelectUsers } from 'containers/User/selectors';
import { selectPaginatedSelectMembers, selectMemberTotal,
  selectIsFetchingMembers
} from 'containers/Group/GroupMembers/selectors';
import {
  getMembersBegin,
  groupMembersUnmount
} from 'containers/Group/GroupMembers/actions';


import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

const MemberTypes = Object.freeze([
  'active',
  'inactive',
  'pending',
  'accepted_users',
  'all',
]);



export function GroupLeaderCreatePage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'members', membersReducer });
  useInjectSaga({ key: 'members', memberSaga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');

  const links = {
    GroupLeadersIndex: ROUTES.group.manage.leaders.index.path(),
  };

  const defaultParams = {
    group_id: groupId,
    query_scopes: ['active']
  };

  const [params, setParams] = useState(defaultParams);
  const [type, setType] = React.useState('accepted_users');
  const [segmentIds, setSegmentIds] = React.useState(null);

  const getScopes = (scopes) => {
    // eslint-disable-next-line no-param-reassign
    if (scopes === undefined) scopes = {};
    if (scopes.type === undefined) scopes.type = type;

    const queryScopes = [];
    if (scopes.type)
      queryScopes.push(scopes.type);
    if (scopes.segmentIds && scopes.segmentIds[1].length > 0)

      return queryScopes;
  };

  const getMembers = (scopes, params = params) => {
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

  useEffect(() => {
    props.getMembersBegin(params);

    return () => {
      props.groupMembersUnmount();
    };
  }, []);
  console.log(props);
  return (
    <GroupLeaderForm
      groupLeaderAction={props.createGroupLeaderBegin}
      buttonText='Create'
      groupId={groupId[0]}
      getUsersBegin={props.getMembersBegin}
      selectUsers={props.members}
      isCommitting={props.isCommitting}
      links={links}
      isFetchingMembers={props.isFetchingMembers}
    />
  );
}

GroupLeaderCreatePage.propTypes = {
  createGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  getMembersBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  members: PropTypes.array,
  groupLeaders: PropTypes.array,
  isCommitting: PropTypes.bool,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  members: selectPaginatedSelectMembers(),
  isCommitting: selectIsCommitting(),
  memberTotal: selectMemberTotal(),
  isFetchingMembers: selectIsFetchingMembers()
});

const mapDispatchToProps = {
  createGroupLeaderBegin,
  groupLeadersUnmount,
  groupMembersUnmount,
  getMembersBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupLeaderCreatePage);
