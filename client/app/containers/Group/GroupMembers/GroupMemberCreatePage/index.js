import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import RouteService from 'utils/routeHelpers';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupMembers/reducer';
import saga from 'containers/Group/GroupMembers/saga';

import { createUserBegin, getUsersBegin, userListUnmount } from 'containers/Group/GroupMembers/actions';
import { selectPaginatedSelectUsers, selectPaginatedUsers, selectUserTotal } from 'containers/Group/GroupMembers/selectors';

import GroupMemberForm from 'components/Group/GroupMembers/GroupMemberForm';

export function GroupMemberCreatePage(props) {
  useInjectReducer({ key: 'members', reducer });
  useInjectSaga({ key: 'members', saga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id')[0];

  useEffect(() => () => props.userListUnmount(), []);

  return (
    <GroupMemberForm
      groupId={groupId}
      createMembersBegin={props.createMembersBegin}
      getUsersBegin={props.getUsersBegin}
      selectUsers={props.users}
    />
  );
}

GroupMemberCreatePage.propTypes = {
  createMembersBegin: PropTypes.func,
  getUsersBegin: PropTypes.func,
  userListUnmount: PropTypes.func,
  users: PropTypes.array
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedSelectUsers(),
  userTotal: selectUserTotal()
});

const mapDispatchToProps = {
  getUsersBegin,
  createMembersBegin: createUserBegin,
  userListUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMemberCreatePage);
