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

import { getGroupLeadersBegin, updateGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';
import {
  selectGroupLeaderTotal, selectIsCommitting, selectFormGroupLeaders,
} from 'containers/Group/GroupManage/GroupLeaders/selectors';
import { getUsersBegin } from 'containers/User/actions';
import { selectPaginatedUsers, selectPaginatedSelectUsers, selectFormUser } from 'containers/User/selectors';


import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

export function GroupLeaderEditPage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'users', reducer: userReducer });
  useInjectSaga({ key: 'users', saga: userSaga });

  const rs = new RouteService(useContext);

  const links = {
    GroupLeadersIndex: ROUTES.group.manage.leaders.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    const groupId = rs.params('group_id');
    props.getGroupLeadersBegin({ group_id: groupId, count: 500 });

    return () => props.groupLeadersUnmount();
  }, []);

  return (
    <GroupLeaderForm
      edit
      getGroupLeaderBegin={props.getGroupLeadersBegin}
      groupLeadersAction={props.updateGroupLeaderBegin}
      getUsersBegin={props.getUsersBegin}
      selectUsers={props.users}
      user={props.user}
      groupLeaders={props.groupLeaders}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      buttonText='Update'
      links={links}
    />
  );
}

GroupLeaderEditPage.propTypes = {
  getGroupLeadersBegin: PropTypes.func,
  updateGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  getUsersBegin: PropTypes.func,
  users: PropTypes.array,
  user: PropTypes.object,
  groupLeaders: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.func,
  groupLeader: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedSelectUsers(),
  isCommitting: selectIsCommitting(),
  user: selectFormUser(),
  groupLeaders: selectFormGroupLeaders()
});

const mapDispatchToProps = {
  updateGroupLeaderBegin,
  getGroupLeadersBegin,
  groupLeadersUnmount,
  getUsersBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupLeaderEditPage);
