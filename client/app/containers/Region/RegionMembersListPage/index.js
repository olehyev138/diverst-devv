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

export function RegionMembersListPage(props) {
  useInjectReducer({ key: 'regions', reducer });
  useInjectSaga({ key: 'regions', saga });

  const { region_id: regionId } = useParams();

  const defaultParams = {
    id: regionId, count: 10, page: 0,
    orderBy: 'id', order: 'asc',
  };

  const [params, setParams] = useState(defaultParams);
  const [segmentIds, setSegmentIds] = React.useState(null);
  const [segmentLabels, setSegmentLabels] = React.useState(null);

  const getScopes = (scopes) => {
    // eslint-disable-next-line no-param-reassign
    if (scopes === undefined) scopes = {};
    if (scopes.segmentIds === undefined) scopes.segmentIds = segmentIds;

    const queryScopes = [];
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

  const handleFilterChange = (values) => {
    let segmentIds = null;
    if (values.segmentIds)
      segmentIds = ['for_segment_ids', values.segmentIds];
    else if (values.segmentLabels)
      segmentIds = ['for_segment_ids', values.segmentLabels.map(label => label.value)];
    setSegmentIds(segmentIds);
    setSegmentLabels(values.segmentLabels);
    getMembers(getScopes({ segmentIds }, defaultParams));
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
