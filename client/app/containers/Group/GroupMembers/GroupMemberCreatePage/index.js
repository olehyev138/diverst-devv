import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupMembers/reducer';
import saga from 'containers/Group/GroupMembers/saga';
import userReducer from 'containers/User/reducer';
import userSaga from 'containers/User/saga';

import { createMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';
import { getUsersBegin } from 'containers/User/actions';
import { selectPaginatedSelectMembers, selectMemberTotal, selectIsCommitting } from 'containers/Group/GroupMembers/selectors';

import GroupMemberForm from 'components/Group/GroupMembers/GroupMemberForm';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import { selectPaginatedSelectUsers } from 'containers/User/selectors';

export function GroupMemberCreatePage(props) {
  useInjectReducer({ key: 'members', reducer });
  useInjectSaga({ key: 'members', saga });
  useInjectReducer({ key: 'users', reducer: userReducer });
  useInjectSaga({ key: 'users', saga: userSaga });

  const { group_id: groupId } = useParams();

  const links = {
    groupMembersIndex: ROUTES.group.members.index.path(groupId),
  };

  useEffect(() => () => props.groupMembersUnmount(), []);

  return (
    <GroupMemberForm
      groupId={groupId}
      createMembersBegin={props.createMembersBegin}
      getMembersBegin={props.getUsersBegin}
      selectUsers={props.users}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

GroupMemberCreatePage.propTypes = {
  createMembersBegin: PropTypes.func,
  getUsersBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedSelectUsers(),
  userTotal: selectMemberTotal(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  getUsersBegin,
  createMembersBegin,
  groupMembersUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  GroupMemberCreatePage,
  ['currentGroup.permissions.members_create?'],
  (props, params) => ROUTES.group.members.index.path(params.group_id),
  permissionMessages.group.groupMembers.createPage
));
