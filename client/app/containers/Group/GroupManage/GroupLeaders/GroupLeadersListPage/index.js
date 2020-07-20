import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupManage/GroupLeaders/reducer';
import saga from 'containers/Group/GroupManage/GroupLeaders/saga';
import {
  getGroupLeadersBegin, deleteGroupLeaderBegin,
  groupLeadersUnmount,
} from 'containers/Group/GroupManage/GroupLeaders/actions';

import {
  selectPaginatedGroupLeaders, selectGroupLeaderTotal,
  selectIsFetchingGroupLeaders,
} from 'containers/Group/GroupManage/GroupLeaders/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupLeadersList from 'components/Group/GroupManage/GroupLeaders/GroupLeadersList';
import { push } from 'connected-react-router';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function GroupLeadersListPage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });

  const { group_id: groupId } = useParams();

  const [params, setParams] = useState({
    group_id: groupId, count: 10, page: 0,
    orderBy: 'id', order: 'asc'
  });

  useEffect(() => {
    props.getGroupLeadersBegin(params);
    return () => {
      props.groupLeadersUnmount();
    };
  }, []);

  const links = {
    groupLeaderNew: ROUTES.group.manage.leaders.new.path(groupId),
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getGroupLeadersBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getGroupLeadersBegin(newParams);
    setParams(newParams);
  };

  return (
    <GroupLeadersList
      group={props.currentGroup}
      groupLeaderList={props.groupLeaderList}
      groupLeaderTotal={props.groupLeaderTotal}
      isFetchingGroupLeaders={props.isFetchingGroupLeaders}
      deleteGroupLeaderBegin={props.deleteGroupLeaderBegin}
      handleVisitGroupLeaderEdit={props.handleVisitGroupLeaderEdit}
      links={links}
      setParams={params}
      params={params}
      handlePagination={handlePagination}
      handleOrdering={handleOrdering}
    />
  );
}

GroupLeadersListPage.propTypes = {
  getGroupLeadersBegin: PropTypes.func,
  deleteGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  groupLeaderList: PropTypes.array,
  groupLeaderTotal: PropTypes.number,
  isFetchingGroupLeaders: PropTypes.bool,
  handleVisitGroupLeaderEdit: PropTypes.func,
  currentGroup: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  groupLeaderList: selectPaginatedGroupLeaders(),
  groupLeaderTotal: selectGroupLeaderTotal(),
  isFetchingGroupLeaders: selectIsFetchingGroupLeaders(),
});

const mapDispatchToProps = dispatch => ({
  getGroupLeadersBegin: payload => dispatch(getGroupLeadersBegin(payload)),
  deleteGroupLeaderBegin: payload => dispatch(deleteGroupLeaderBegin(payload)),
  groupLeadersUnmount: () => dispatch(groupLeadersUnmount()),
  handleVisitGroupLeaderEdit: (groupId, id) => dispatch(push(ROUTES.group.manage.leaders.edit.path(groupId, id))),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  GroupLeadersListPage,
  ['currentGroup.permissions.leaders_view?'],
  (props, params) => ROUTES.group.manage.index.path(params.group_id),
  permissionMessages.group.groupManage.groupLeaders.listPage
));