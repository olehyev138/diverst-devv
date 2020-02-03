import React, {
  memo, useContext, useEffect
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

import { createGroupLeaderBegin, groupLeadersUnmount } from 'containers/Group/GroupManage/GroupLeaders/actions';
import { selectIsCommitting } from 'containers/Group/GroupManage/GroupLeaders/selectors';

import { selectPaginatedSelectMembers } from 'containers/Group/GroupMembers/selectors';
import { getMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';

import GroupLeaderForm from 'components/Group/GroupManage/GroupLeaders/GroupLeaderForm';

export function GroupLeaderCreatePage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });
  useInjectReducer({ key: 'members', reducer: memberReducer });
  useInjectSaga({ key: 'members', saga: memberSaga });

  const { isCommitting, members, ...rest } = props;

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id');

  const links = {
    index: ROUTES.group.manage.leaders.index.path(groupId),
  };

  useEffect(() => () => {
    props.groupLeadersUnmount();
    props.groupMembersUnmount();
  }, []);

  return (
    <GroupLeaderForm
      groupLeaderAction={props.createGroupLeaderBegin}
      buttonText='Create'
      groupId={groupId[0]}
      getMembersBegin={props.getMembersBegin}
      selectMembers={members}
      isCommitting={isCommitting}
      links={links}
    />
  );
}

GroupLeaderCreatePage.propTypes = {
  createGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  getMembersBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  members: PropTypes.array,
  groupLeaders: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  members: selectPaginatedSelectMembers(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  createGroupLeaderBegin,
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
)(GroupLeaderCreatePage);
