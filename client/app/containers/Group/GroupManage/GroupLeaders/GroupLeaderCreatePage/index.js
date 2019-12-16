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

import { createGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';
import {
  selectGroupLeaderTotal, selectIsCommitting
} from 'containers/Group/GroupManage/GroupLeaders/selectors';
import { getUsersBegin } from 'containers/User/actions';
import { selectPaginatedSelectUsers } from 'containers/User/selectors';


import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

export function GroupLeaderCreatePage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'users', reducer: userReducer });
  useInjectSaga({ key: 'users', saga: userSaga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');

  const links = {
    GroupLeadersIndex: ROUTES.group.manage.leaders.index.path(),
  };

  useEffect(() => () => props.groupLeadersUnmount(), []);

  return (
    <GroupLeaderForm
      groupLeaderAction={props.createGroupLeaderBegin}
      buttonText='Create'
      groupId={groupId[0]}
      getUsersBegin={props.getUsersBegin}
      selectUsers={props.users}
      isCommitting={props.isCommitting}
      links={links}
    />
  );
}

GroupLeaderCreatePage.propTypes = {
  createGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  getUsersBegin: PropTypes.func,
  users: PropTypes.array,
  groupLeaders: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedSelectUsers(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createGroupLeaderBegin,
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
)(GroupLeaderCreatePage);
