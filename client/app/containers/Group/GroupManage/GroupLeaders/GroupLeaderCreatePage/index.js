import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Group/GroupManage/GroupLeaders/reducer';
import saga from 'containers/Group/GroupManage/GroupLeaders/saga';

import memberReducer from 'containers/Group/GroupMembers/reducer';
import memberSaga from 'containers/Group/GroupMembers/saga';

import userRoleReducer from 'containers/User/UserRole/reducer';
import userRoleSaga from 'containers/User/UserRole/saga';

import { createGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';
import { selectIsCommitting } from 'containers/Group/GroupManage/GroupLeaders/selectors';

import { selectPaginatedSelectMembers, selectIsFetchingMembers } from 'containers/Group/GroupMembers/selectors';
import { getMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';

import { selectPaginatedSelectUserRoles } from 'containers/User/UserRole/selectors';
import { getUserRolesBegin, userRoleUnmount } from 'containers/User/UserRole/actions';

import { selectCustomText } from 'containers/Shared/App/selectors';

import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupManage/messages';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupLeaderCreatePage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'members', reducer: memberReducer });
  useInjectSaga({ key: 'members', saga: memberSaga });
  useInjectReducer({ key: 'roles', reducer: userRoleReducer });
  useInjectSaga({ key: 'roles', saga: userRoleSaga });

  const { isCommitting, members, ...rest } = props;

  const { group_id: groupId } = useParams();

  const links = {
    index: ROUTES.group.manage.leaders.index.path(groupId),
  };

  useEffect(() => {
    props.getUserRolesBegin({ role_type: 'group' });
    props.getMembersBegin({
      count: 25, page: 0, order: 'asc',
      group_id: groupId,
      query_scopes: ['active', 'accepted_users', ['user_search', '']]
    });

    return () => {
      props.groupLeadersUnmount();
      props.groupMembersUnmount();
      props.userRoleUnmount();
    };
  }, []);

  return (
    <GroupLeaderForm
      groupLeaderAction={props.createGroupLeaderBegin}
      buttonText={messages.create}
      groupId={groupId}
      getMembersBegin={props.getMembersBegin}
      selectMembers={members}
      userRoles={props.userRoles}
      isCommitting={isCommitting}
      links={links}
      isLoadingMembers={props.isLoadingMembers}
      customTexts={props.customTexts}
    />
  );
}

GroupLeaderCreatePage.propTypes = {
  createGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  getMembersBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  getUserRolesBegin: PropTypes.func,
  userRoleUnmount: PropTypes.func,
  members: PropTypes.array,
  userRoles: PropTypes.array,
  groupLeaders: PropTypes.array,
  isCommitting: PropTypes.bool,
  isLoadingMembers: PropTypes.bool,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  members: selectPaginatedSelectMembers(),
  userRoles: selectPaginatedSelectUserRoles(),
  isCommitting: selectIsCommitting(),
  isLoadingMembers: selectIsFetchingMembers(),
  customTexts: selectCustomText()
});

const mapDispatchToProps = {
  createGroupLeaderBegin,
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
)(Conditional(
  GroupLeaderCreatePage,
  ['currentGroup.permissions.leaders_create?'],
  (props, params) => ROUTES.group.manage.index.path(params.group_id),
  permissionMessages.group.groupManage.groupLeaders.createPage
));
