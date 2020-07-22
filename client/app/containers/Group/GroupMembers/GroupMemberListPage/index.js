import React, {
  memo, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupMembers/reducer';
import saga from 'containers/Group/GroupMembers/saga';

import {
  getMembersBegin, deleteMemberBegin,
  groupMembersUnmount, exportMembersBegin
} from 'containers/Group/GroupMembers/actions';
import {
  selectPaginatedMembers, selectMemberTotal,
  selectIsFetchingMembers
} from 'containers/Group/GroupMembers/selectors';

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';

import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupMemberList from 'components/Group/GroupMembers/GroupMemberList';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

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

  const { group_id: groupId } = useParams();

  const defaultParams = {
    group_id: groupId, count: 10, page: 0,
    orderBy: 'users.id', order: 'asc',
    query_scopes: ['active']
  };

  const [params, setParams] = useState(defaultParams);
  const [type, setType] = React.useState('accepted_users');
  const [from, setFrom] = React.useState(null);
  const [to, setTo] = React.useState(null);
  const [segmentIds, setSegmentIds] = React.useState(null);
  const [segmentLabels, setSegmentLabels] = React.useState(null);

  const getScopes = (scopes) => {
    // eslint-disable-next-line no-param-reassign
    if (scopes === undefined) scopes = {};
    if (scopes.type === undefined) scopes.type = type;
    if (scopes.from === undefined) scopes.from = from;
    if (scopes.to === undefined) scopes.to = to;
    if (scopes.segmentIds === undefined) scopes.segmentIds = segmentIds;

    const queryScopes = [];
    if (scopes.type)
      queryScopes.push(scopes.type);
    if (scopes.from)
      queryScopes.push(scopes.from);
    if (scopes.to)
      queryScopes.push(scopes.to);
    if (scopes.segmentIds && scopes.segmentIds[1].length > 0)
      queryScopes.push(scopes.segmentIds);

    return queryScopes;
  };

  const getMembers = (scopes, params = params) => {
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

  const exportMembers = (gID = groupId) => {
    if (gID) {
      const newParams = {
        ...params,
        group_id: gID,
        query_scopes: getScopes({})
      };
      props.exportMembersBegin(newParams);
    }
  };

  const exportGroupsMembers = (groups = []) => {
    groups.forEach(group => exportMembers(group));
  };

  const handleChangeTab = (type) => {
    setType(type);
    if (MemberTypes.includes(type))
      getMembers(getScopes({ type }), defaultParams);
  };

  const handleFilterChange = (values) => {
    let from = null;
    let to = null;
    let segmentIds = null;
    if (values.from) {
      from = ['joined_from', values.from];
      setFrom(from);
    }
    if (values.to) {
      to = ['joined_to', values.to];
      setTo(to);
    }
    if (values.segmentIds) {
      segmentIds = ['for_segment_ids', values.segmentIds];
      setSegmentIds(segmentIds);
    }
    if (values.segmentLabels) {
      segmentIds = ['for_segment_ids', values.segmentIds];
      setSegmentIds(segmentIds);
      setSegmentLabels(values.segmentLabels);
    }
    getMembers(getScopes({ from, to, segmentIds }, defaultParams));
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getMembers(getScopes({}), newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getMembers(getScopes({}), newParams);
  };

  const handleSearching = (searchText) => {
    const newParams = { ...params, search: searchText };

    getMembers(getScopes({}), newParams);
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

  const formGroupFamily = (group) => {
    if (!group)
      return [];
    return [{ label: group.name, id: group.id, value: true }].concat(
      (group.parent ? [{ label: group.parent.name, id: group.parent.id, value: false }] : []),
      group.children.map(subGroup => ({ label: subGroup.name, id: subGroup.id, value: false }))
    );
  };

  return (
    <React.Fragment>
      <DiverstBreadcrumbs />
      <GroupMemberList
        memberList={props.memberList}
        memberTotal={props.memberTotal}
        isFetchingMembers={props.isFetchingMembers}
        groupId={groupId}
        currentGroup={props.currentGroup}
        deleteMemberBegin={props.deleteMemberBegin}
        exportMembersBegin={exportMembers}
        exportGroupsMembers={exportGroupsMembers}
        formGroupFamily={formGroupFamily(props.currentGroup)}
        links={links}
        setParams={params}
        params={params}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        handleSearching={handleSearching}

        memberType={type}
        MemberTypes={MemberTypes}
        handleChangeTab={handleChangeTab}

        memberFrom={from ? from[1] : null}
        memberTo={to ? to[1] : null}
        segmentLabels={segmentLabels || []}
        handleFilterChange={handleFilterChange}
      />
    </React.Fragment>
  );
}

GroupMemberListPage.propTypes = {
  getMembersBegin: PropTypes.func,
  deleteMemberBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  exportMembersBegin: PropTypes.func,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool,
  currentGroup: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  memberList: selectPaginatedMembers(),
  memberTotal: selectMemberTotal(),
  isFetchingMembers: selectIsFetchingMembers()
});

const mapDispatchToProps = {
  getMembersBegin,
  deleteMemberBegin,
  exportMembersBegin,
  groupMembersUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  GroupMemberListPage,
  ['currentGroup.permissions.members_view?'],
  (props, params) => ROUTES.group.home.path(params.group_id),
  permissionMessages.group.groupMembers.listPage
));
