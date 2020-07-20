/**
 *
 * SegmentListPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/Segment/saga';
import reducer from 'containers/Segment/reducer';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectPaginatedSegments, selectSegmentTotal, selectIsLoading } from 'containers/Segment/selectors';
import { getSegmentsBegin, segmentUnmount, deleteSegmentBegin } from 'containers/Segment/actions';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';

import SegmentList from 'components/Segment/SegmentList';
import { push } from 'connected-react-router';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SegmentListPage(props) {
  useInjectReducer({ key: 'segments', reducer });
  useInjectSaga({ key: 'segments', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  const links = {
    segmentNew: ROUTES.admin.manage.segments.new.path(),
    segmentPage: id => ROUTES.admin.manage.segments.show.path(id)
  };

  useEffect(() => {
    props.getSegmentsBegin(params);

    return () => {
      props.segmentUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getSegmentsBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getSegmentsBegin(newParams);
    setParams(newParams);
  };

  const handleSearching = (searchText) => {
    const newParams = { ...params, search: searchText };

    props.getSegmentsBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <SegmentList
        segments={props.segments}
        segmentTotal={props.segmentTotal}
        isLoading={props.isLoading}
        deleteSegmentBegin={props.deleteSegmentBegin}
        handleSegmentEdit={props.handleSegmentEdit}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        handleSearching={handleSearching}
        links={links}
        currentEnterprise={props.currentEnterprise}
      />
    </React.Fragment>
  );
}

SegmentListPage.propTypes = {
  getSegmentsBegin: PropTypes.func.isRequired,
  segmentUnmount: PropTypes.func.isRequired,
  segments: PropTypes.object,
  segmentTotal: PropTypes.number,
  deleteSegmentBegin: PropTypes.func,
  isLoading: PropTypes.bool,
  handleSegmentEdit: PropTypes.func,

  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  })
};

const mapStateToProps = createStructuredSelector({
  segments: selectPaginatedSegments(),
  segmentTotal: selectSegmentTotal(),
  isLoading: selectIsLoading(),
  currentEnterprise: selectEnterprise(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = dispatch => ({
  getSegmentsBegin: payload => dispatch(getSegmentsBegin(payload)),
  deleteSegmentBegin: payload => dispatch(deleteSegmentBegin(payload)),
  segmentUnmount: () => dispatch(segmentUnmount()),
  handleSegmentEdit: id => dispatch(push(ROUTES.admin.manage.segments.edit.path(id)))
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  SegmentListPage,
  ['permissions.segments_create'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.segment.listPage
));
