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
import reducer from 'containers/Group/GroupMembers/reducer';
import saga from 'containers/Group/GroupMembers/saga';

import { createMembersBegin, getMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';
import { selectPaginatedSelectMembers, selectMemberTotal, selectIsCommitting } from 'containers/Group/GroupMembers/selectors';

import GroupMemberForm from 'components/Group/GroupMembers/GroupMemberForm';
import Conditional from 'components/Compositions/Conditional';

export function GroupMemberCreatePage(props) {
  useInjectReducer({ key: 'members', reducer });
  useInjectSaga({ key: 'members', saga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');
  const links = {
    groupMembersIndex: ROUTES.group.members.index.path(groupId),
  };

  useEffect(() => () => props.groupMembersUnmount(), []);

  return (
    <GroupMemberForm
      groupId={groupId}
      createMembersBegin={props.createMembersBegin}
      getMembersBegin={props.getMembersBegin}
      selectUsers={props.users}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

GroupMemberCreatePage.propTypes = {
  createMembersBegin: PropTypes.func,
  getMembersBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  users: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedSelectMembers(),
  userTotal: selectMemberTotal(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  getMembersBegin,
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
  ['currentGroup.permissions.members_manage?'],
  (props, rs) => ROUTES.group.members.index.path(rs.params('group_id')),
  'You don\'t have permission to add members'
));
