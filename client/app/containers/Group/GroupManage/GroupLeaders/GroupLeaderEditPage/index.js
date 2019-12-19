import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupManage/GroupLeaders/reducer';
import saga from 'containers/Group/GroupManage/GroupLeaders/saga';
import userReducer from 'containers/User/reducer';
import userSaga from 'containers/User/saga';
import memberReducer from 'containers/Group/GroupMembers/reducer';
import memberSaga from 'containers/Group/GroupMembers/saga';
import { selectPaginatedSelectMembersLeaderForm, selectMemberTotal,
  selectIsFetchingMembers
} from 'containers/Group/GroupMembers/selectors';
import {
  getMembersBegin,
} from 'containers/Group/GroupMembers/actions';


import { getGroupLeaderBegin, updateGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';
import {
  selectGroupLeaderTotal, selectPaginatedSelectGroupLeaders, selectIsCommitting, selectFormGroupLeaders, selectFormGroupLeader
} from 'containers/Group/GroupManage/GroupLeaders/selectors';


import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

export function GroupLeaderEditPage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'members', reducer: memberReducer });
  useInjectSaga({ key: 'members', saga: memberSaga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');
  const groupLeaderId = rs.params('group_leader_id');
  const links = {
    GroupLeadersIndex: ROUTES.group.manage.leaders.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    props.getGroupLeaderBegin({ group_id: groupId, id: groupLeaderId });
    props.getMembersBegin({ group_id: groupId, count: 500, query_scopes: ['active'] });
    return () => props.groupLeadersUnmount();
  }, []);
  console.log(props);
  return (
    <GroupLeaderForm
      edit
      getGroupLeaderBegin={props.getGroupLeaderBegin}
      groupLeader={props.groupLeader}
      groupLeaderId={rs.params('group_leader_id'[0])}
      groupLeaderAction={props.updateGroupLeaderBegin}
      getMembersBegin={props.getMembersBegin}
      selectMembers={props.members}
      member={props.member}
      groupId={groupId[0]}
      groupMembers={props.members}
      groupLeaders={props.groupLeaders}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      buttonText='Update'
      links={links}
    />
  );
}

GroupLeaderEditPage.propTypes = {
  getGroupLeaderBegin: PropTypes.func,
  getGroupMembersBegin: PropTypes.func,
  updateGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  getMembersBegin: PropTypes.func,
  members: PropTypes.array,
  member: PropTypes.object,
  groupLeaders: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.func,
  groupLeader: PropTypes.object,
  groupLeaderId: PropTypes.string,
};

const mapStateToProps = createStructuredSelector({
  members: selectPaginatedSelectMembersLeaderForm(),
  groupLeaders: selectPaginatedSelectGroupLeaders(),
  isCommitting: selectIsCommitting(),
  groupLeader: selectFormGroupLeader(),
  // groupLeaders: selectFormGroupLeaders()
});

const mapDispatchToProps = {
  updateGroupLeaderBegin,
  getGroupLeaderBegin,
  groupLeadersUnmount,
  getMembersBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupLeaderEditPage);
