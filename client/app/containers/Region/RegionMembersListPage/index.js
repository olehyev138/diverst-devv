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
import reducer from 'containers/Region/reducer';
import saga from 'containers/Region/saga';

import {
  getRegionMembersBegin, regionMembersUnmount
} from 'containers/Region/actions';

import {
  selectPaginatedMembers, selectMemberTotal, selectMembersIsLoading,
} from 'containers/Region/selectors';

import DiverstBreadcrumbs from 'components/Shared/DiverstBreadcrumbs';

import { ROUTES } from 'containers/Shared/Routes/constants';

import RegionMembersList from 'components/Region/RegionMembersList';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

const MemberTypes = Object.freeze([
  'active',
  'inactive',
  'pending',
  'accepted_users',
  'all',
]);

export function RegionMembersListPage(props) {
  useInjectReducer({ key: 'regions', reducer });
  useInjectSaga({ key: 'regions', saga });

  const { region_id: regionId } = useParams();

  const defaultParams = {
    id: regionId, count: 10, page: 0,
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
    if (regionId) {
      const newParams = {
        ...params,
        id: regionId,
        query_scopes: scopes
      };
      props.getRegionMembersBegin(newParams);
      setParams(newParams);
    }
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
    if (values.from)
      from = ['joined_from', values.from];
    setFrom(from);
    if (values.to)
      to = ['joined_to', values.to];
    setTo(to);
    if (values.segmentIds)
      segmentIds = ['for_segment_ids', values.segmentIds];
    else if (values.segmentLabels)
      segmentIds = ['for_segment_ids', values.segmentLabels.map(label => label.value)];
    setSegmentIds(segmentIds);
    setSegmentLabels(values.segmentLabels);
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
    props.getRegionMembersBegin(params);

    return () => {
      props.regionMembersUnmount();
    };
  }, []);

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
      <RegionMembersList
        memberList={props.memberList}
        memberTotal={props.memberTotal}
        isLoading={props.isLoading}
        regionId={regionId}
        currentRegion={props.currentRegion}
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

RegionMembersListPage.propTypes = {
  getRegionMembersBegin: PropTypes.func,
  regionMembersUnmount: PropTypes.func,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  currentRegion: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  memberList: selectPaginatedMembers(),
  memberTotal: selectMemberTotal(),
  isLoading: selectMembersIsLoading(),
});

const mapDispatchToProps = {
  getRegionMembersBegin,
  regionMembersUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  RegionMembersListPage,
  ['currentRegion.permissions.members_view?'],
  (props, params) => ROUTES.region.home.path(params.region_id),
  permissionMessages.region.membersListPage
));
