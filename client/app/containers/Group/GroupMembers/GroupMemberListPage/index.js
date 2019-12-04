import React, {
  memo, useEffect, useContext, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupMembers/reducer';
import saga from 'containers/Group/GroupMembers/saga';

import {
  getMembersBegin, deleteMemberBegin,
  groupMembersUnmount
} from 'containers/Group/GroupMembers/actions';
import {
  selectPaginatedMembers, selectMemberTotal,
  selectIsFetchingMembers
} from 'containers/Group/GroupMembers/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupMemberList from 'components/Group/GroupMembers/GroupMemberList';

const MemberTypes = Object.freeze([
  'active',
  'inactive',
  'pending',
  'accepted_users',
  'all',
]);

const getCurrentDay = () => {
  const d = new Date();
  d.setHours(0);
  d.setMinutes(0);
  d.setSeconds(0);
  d.setMilliseconds(0);
  return d;
};

export function GroupMemberListPage(props) {
  useInjectReducer({ key: 'members', reducer });
  useInjectSaga({ key: 'members', saga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id')[0];

  const defaultParams = {
    group_id: groupId, count: 10, page: 0,
    orderBy: 'users.id', order: 'asc',
    query_scopes: ['active']
  };

  const [params, setParams] = useState(defaultParams);
  const [type, setType] = React.useState('accepted_users');
  const [from, setFrom] = React.useState(null);
  const [to, setTo] = React.useState(null);
  const [segments, setSegments] = React.useState(null);

  const getScopes = (scopes) => {
    // eslint-disable-next-line no-param-reassign
    if (scopes === undefined) scopes = {};
    if (scopes.type === undefined) scopes.type = type;
    if (scopes.from === undefined) scopes.from = from;
    if (scopes.to === undefined) scopes.to = to;
    if (scopes.segments === undefined) scopes.segments = segments;

    const queryScopes = [];
    if (scopes.type)
      queryScopes.push(scopes.type);
    if (scopes.from)
      queryScopes.push(scopes.from);
    if (scopes.to)
      queryScopes.push(scopes.to);
    if (scopes.segments)
      queryScopes.push(scopes.segments);

    return queryScopes;
  };

  const getMembers = (scopes, resetParams = false) => {
    if (resetParams)
      setParams(defaultParams);

    if (groupId) {
      const newParams = {
        ...params,
        group_id: groupId,
        query_scopes: scopes
      };
      props.getMembersBegin(newParams);
      setParams(newParams);
    }
  };

  const handleChangeTab = (type) => {
    setType(type);
    if (MemberTypes.includes(type))
      getMembers(getScopes({ type }), true);
  };

  const handleDateFilter = (values) => {
    let from;
    let to;
    if (values.from) {
      from = ['joined_from', values.from];
      setFrom(from);
    }
    if (values.to) {
      to = ['joined_to', values.to];
      setTo(to);
    }
    getMembers(getScopes({ from, to }, true));
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getMembers(getScopes({}), false);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getMembers(getScopes({}), false);
    setParams(newParams);
  };

  useEffect(() => {
    props.getMembersBegin(params);

    return () => {
      props.groupMembersUnmount();
    };
  }, []);

  const links = {
    groupMembersNew: ROUTES.group.members.new.path(groupId),
  };

  return (
    <React.Fragment>
      <GroupMemberList
        memberList={props.memberList}
        memberTotal={props.memberTotal}
        isFetchingMembers={props.isFetchingMembers}
        groupId={groupId}
        deleteMemberBegin={props.deleteMemberBegin}
        links={links}
        setParams={params}
        params={params}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}

        memberType={type}
        MemberTypes={MemberTypes}
        handleChangeTab={handleChangeTab}

        memberFrom={from ? from[1] : null}
        memberTo={to ? to[1] : null}
        handleDateFilter={handleDateFilter}
      />
    </React.Fragment>
  );
}

GroupMemberListPage.propTypes = {
  getMembersBegin: PropTypes.func,
  deleteMemberBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool
};

const mapStateToProps = createStructuredSelector({
  memberList: selectPaginatedMembers(),
  memberTotal: selectMemberTotal(),
  isFetchingMembers: selectIsFetchingMembers()
});

const mapDispatchToProps = {
  getMembersBegin,
  deleteMemberBegin,
  groupMembersUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMemberListPage);
