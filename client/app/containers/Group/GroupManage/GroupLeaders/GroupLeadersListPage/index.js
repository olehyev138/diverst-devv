import React, {
  memo, useEffect, useContext, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

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
  selectIsFetchingGroupLeaders, selectFormGroupLeader,
} from 'containers/Group/GroupManage/GroupLeaders/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupLeadersList from 'components/Group/GroupManage/GroupLeaders/GroupLeadersList';
import { push } from 'connected-react-router';

export function GroupLeadersListPage(props) {
  useInjectReducer({ key: 'groupLeaders', reducer });
  useInjectSaga({ key: 'groupLeaders', saga });

  const rs = new RouteService(useContext);

  const groupId = rs.params('group_id')[0];

  const groupLeaderId = rs.params('group_leader_id');

  const [params, setParams] = useState({
    group_id: groupId, count: 10, page: 0,
    orderBy: 'id', order: 'asc'
  });
  const links = {
    groupLeaderNew: ROUTES.group.manage.leaders.new.path(),
    groupLeaderEdit: id => ROUTES.group.manage.leaders.edit.path(id),
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

  useEffect(() => {
    props.getGroupLeadersBegin(params);
    console.log(props);

    return () => {
      props.groupLeadersUnmount();
    };
  }, []);

  return (
    props.currentGroup && (
      <React.Fragment>
        <GroupLeadersList
          group={props.currentGroup}
          groupLeaderList={props.groupLeaderList}
          groupLeaderTotal={props.groupLeaderTotal}
          isFetchingGroupLeaders={props.isFetchingGroupLeaders}
          deleteGroupLeaderBegin={props.deleteGroupLeaderBegin}
          handleVisitGroupLeaderEdit={props.handleVisitGroupLeaderEdit}
          handleVisitGroupLeaderShow={props.handleVisitGroupLeaderShow}
          links={links}
          setParams={params}
          params={params}
          handlePagination={handlePagination}
          handleOrdering={handleOrdering}
        />
      </React.Fragment>
    )
  );
}

GroupLeadersListPage.propTypes = {
  getGroupLeadersBegin: PropTypes.func,
  deleteGroupLeaderBegin: PropTypes.func,
  groupLeadersUnmount: PropTypes.func,
  groupLeaderList: PropTypes.array,
  groupLeaderTotal: PropTypes.number,
  isFetchingGroupLeaders: PropTypes.bool,
  groupLeader: PropTypes.object,
  handleVisitGroupLeaderEdit: PropTypes.func,
  group: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  groupLeaderList: selectPaginatedGroupLeaders(),
  groupLeaderTotal: selectGroupLeaderTotal(),
  isFetchingGroupLeaders: selectIsFetchingGroupLeaders(),
  groupLeader: selectFormGroupLeader(),
});

const mapDispatchToProps = dispatch => ({
  getGroupLeadersBegin: payload => dispatch(getGroupLeadersBegin(payload)),
  deleteGroupLeaderBegin: payload => dispatch(deleteGroupLeaderBegin(payload)),
  groupLeadersUnmount: () => dispatch(groupLeadersUnmount()),
  handleVisitGroupLeaderEdit: id => dispatch(push(ROUTES.groups.manage.leaders.edit.path(id))),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupLeadersListPage);
