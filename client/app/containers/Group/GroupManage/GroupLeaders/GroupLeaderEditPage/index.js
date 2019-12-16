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

import { getGroupLeaderBegin, updateGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';
import {
  selectGroupLeaderTotal, selectIsCommitting, selectFormGroupLeader,
} from 'containers/Group/GroupManage/GroupLeaders/selectors';
import { getUsersBegin } from 'containers/User/actions';
import { selectPaginatedUsers, selectPaginatedSelectUsers, selectFormUser } from 'containers/User/selectors';


import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

export function GroupLeaderEditPage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'users', reducer: userReducer });
  useInjectSaga({ key: 'users', saga: userSaga });

  const links = {
    GroupLeadersIndex: ROUTES.group.manage.leaders.index.path(),
  };

  useEffect(() => () => props.groupLeadersUnmount(), []);

  return (
    <GroupLeaderForm
      edit
      getGroupLeaderBegin={props.getGroupLeaderBegin}
      groupLeaderAction={props.updateGroupLeaderBegin}
      getUsersBegin={props.getUsersBegin}
      selectUsers={props.users}
      user={props.user}
      groupLeader={props.groupLeader}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      buttonText='Update'
      links={links}
    />
  );
}

GroupLeaderEditPage.propTypes = {
  getGroupLeaderBegin: PropTypes.func,
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
  groupLeader: selectFormGroupLeader()
});

const mapDispatchToProps = {
  updateGroupLeaderBegin,
  getGroupLeaderBegin,
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
