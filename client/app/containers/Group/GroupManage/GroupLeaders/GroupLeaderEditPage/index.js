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

import memberReducer from 'containers/Group/GroupMembers/reducer';
import memberSaga from 'containers/Group/GroupMembers/saga';

import userRoleReducer from 'containers/User/UserRole/reducer';
import userRoleSaga from 'containers/User/UserRole/saga';

import { selectPaginatedSelectMembers } from 'containers/Group/GroupMembers/selectors';
import { getMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';

import { selectIsCommitting, selectFormGroupLeader, selectIsFormLoading } from 'containers/Group/GroupManage/GroupLeaders/selectors';
import { getGroupLeaderBegin, updateGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';

import { selectPaginatedSelectUserRoles } from 'containers/User/UserRole/selectors';
import { getUserRolesBegin, userRoleUnmount } from 'containers/User/UserRole/actions';

import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupManage/messages';

export function GroupLeaderEditPage(props) {
  const { members, groupLeader, isCommitting, isFormLoading, ...rest } = props;

  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'members', reducer: memberReducer });
  useInjectSaga({ key: 'members', saga: memberSaga });
  useInjectReducer({ key: 'roles', reducer: userRoleReducer });
  useInjectSaga({ key: 'roles', saga: userRoleSaga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');
  const groupLeaderId = rs.params('group_leader_id');

  const links = {
    index: ROUTES.group.manage.leaders.index.path(groupId),
  };

  useEffect(() => {
    props.getGroupLeaderBegin({ group_id: groupId, id: groupLeaderId });
    props.getUserRolesBegin({ role_type: 'group' });

    return () => {
      props.groupLeadersUnmount();
      props.groupMembersUnmount();
      props.userRoleUnmount();
    };
  }, []);

  return (
    <GroupLeaderForm
      edit
      getGroupLeaderBegin={props.getGroupLeaderBegin}
      groupLeader={groupLeader}
      groupLeaderAction={props.updateGroupLeaderBegin}
      getMembersBegin={props.getMembersBegin}
      selectMembers={members}
      userRoles={props.userRoles}
      groupId={groupId}
      isCommitting={isCommitting}
      isFormLoading={isFormLoading}
      buttonText={<DiverstFormattedMessage {...messages.update} />}
      links={links}
    />
  );
}

GroupLeaderEditPage.propTypes = {
  getGroupLeaderBegin: PropTypes.func,
  getGroupMembersBegin: PropTypes.func,
  updateGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  userRoleUnmount: PropTypes.func,
  getMembersBegin: PropTypes.func,
  getUserRolesBegin: PropTypes.func,
  members: PropTypes.array,
  userRoles: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  groupLeader: PropTypes.object,
  groupLeaderId: PropTypes.string,
};

const mapStateToProps = createStructuredSelector({
  members: selectPaginatedSelectMembers(),
  groupLeader: selectFormGroupLeader(),
  userRoles: selectPaginatedSelectUserRoles(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  updateGroupLeaderBegin,
  getGroupLeaderBegin,
  getMembersBegin,
  getUserRolesBegin,
  groupLeadersUnmount,
  groupMembersUnmount,
  userRoleUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupLeaderEditPage);
