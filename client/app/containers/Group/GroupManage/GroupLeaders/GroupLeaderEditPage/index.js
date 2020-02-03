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

import { selectPaginatedSelectMembers } from 'containers/Group/GroupMembers/selectors';
import { getMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';

import { selectIsCommitting, selectFormGroupLeader, selectIsFormLoading } from 'containers/Group/GroupManage/GroupLeaders/selectors';
import { getGroupLeaderBegin, updateGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';

import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

export function GroupLeaderEditPage(props) {
  const { members, groupLeader, isCommitting, isFormLoading, ...rest } = props;

  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'members', reducer: memberReducer });
  useInjectSaga({ key: 'members', saga: memberSaga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');
  const groupLeaderId = rs.params('group_leader_id');

  const links = {
    index: ROUTES.group.manage.leaders.index.path(groupId),
  };

  useEffect(() => {
    props.getGroupLeaderBegin({ group_id: groupId, id: groupLeaderId });
    props.getMembersBegin({ group_id: groupId, count: 500, query_scopes: ['active'] });

    return () => {
      props.groupLeadersUnmount();
      props.groupMembersUnmount();
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
      groupId={groupId}
      isCommitting={isCommitting}
      isFormLoading={isFormLoading}
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
  groupMembersUnmount: PropTypes.func,
  getMembersBegin: PropTypes.func,
  members: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  groupLeader: PropTypes.object,
  groupLeaderId: PropTypes.string,
};

const mapStateToProps = createStructuredSelector({
  members: selectPaginatedSelectMembers(),
  groupLeader: selectFormGroupLeader(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  updateGroupLeaderBegin,
  getGroupLeaderBegin,
  getMembersBegin,
  groupLeadersUnmount,
  groupMembersUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupLeaderEditPage);
