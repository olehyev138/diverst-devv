import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Region/RegionLeaders/reducer';
import saga from 'containers/Region/RegionLeaders/saga';
import {
  getRegionLeadersBegin, deleteRegionLeaderBegin,
  regionLeadersUnmount,
} from 'containers/Region/RegionLeaders/actions';

import {
  selectPaginatedRegionLeaders, selectRegionLeaderTotal,
  selectIsFetchingRegionLeaders,
} from 'containers/Region/RegionLeaders/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

import RegionLeadersList from 'components/Region/RegionLeaders/RegionLeadersList';
import { push } from 'connected-react-router';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function RegionLeadersListPage(props) {
  useInjectReducer({ key: 'regionLeaders', reducer });
  useInjectSaga({ key: 'regionLeaders', saga });

  const { region_id: regionId } = useParams();

  const [params, setParams] = useState({
    region_id: regionId, count: 10, page: 0,
    orderBy: 'id', order: 'asc'
  });

  useEffect(() => {
    props.getRegionLeadersBegin(params);
    return () => {
      props.regionLeadersUnmount();
    };
  }, []);

  const links = {
    regionLeaderNew: ROUTES.region.leaders.new.path(regionId),
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getRegionLeadersBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getRegionLeadersBegin(newParams);
    setParams(newParams);
  };

  return (
    <RegionLeadersList
      region={props.currentRegion}
      regionLeaderList={props.regionLeaderList}
      regionLeaderTotal={props.regionLeaderTotal}
      isFetchingRegionLeaders={props.isFetchingRegionLeaders}
      deleteGroupRegionBegin={props.deleteRegionLeaderBegin}
      handleVisitRegionLeaderEdit={props.handleVisitRegionLeaderEdit}
      links={links}
      setParams={params}
      params={params}
      handlePagination={handlePagination}
      handleOrdering={handleOrdering}
    />
  );
}

RegionLeadersListPage.propTypes = {
  getRegionLeadersBegin: PropTypes.func,
  deleteRegionLeaderBegin: PropTypes.func,
  regionLeadersUnmount: PropTypes.func,
  regionLeaderList: PropTypes.array,
  regionLeaderTotal: PropTypes.number,
  isFetchingRegionLeaders: PropTypes.bool,
  handleVisitRegionLeaderEdit: PropTypes.func,
  currentRegion: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  regionLeaderList: selectPaginatedRegionLeaders(),
  regionLeaderTotal: selectRegionLeaderTotal(),
  isFetchingRegionLeaders: selectIsFetchingRegionLeaders(),
});

const mapDispatchToProps = dispatch => ({
  getRegionLeadersBegin: payload => dispatch(getRegionLeadersBegin(payload)),
  deleteRegionLeaderBegin: payload => dispatch(deleteRegionLeaderBegin(payload)),
  regionLeadersUnmount: () => dispatch(regionLeadersUnmount()),
  handleVisitRegionLeaderEdit: (regionId, id) => dispatch(push(ROUTES.region.leaders.edit.path(regionId, id))),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  RegionLeadersListPage,
  ['currentRegion.permissions.leaders_view?'],
  (props, params) => ROUTES.region.home.path(params.region_id),
  permissionMessages.region.leaders.listPage
));
