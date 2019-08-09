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

import { selectPaginatedSegments, selectSegmentTotal } from 'containers/Segment/selectors';
import { getSegmentsBegin, segmentUnmount, deleteSegmentBegin } from 'containers/Segment/actions';

import SegmentList from 'components/Segment/SegmentList';

export function SegmentListPage(props) {
  useInjectReducer({ key: 'segments', reducer });
  useInjectSaga({ key: 'segments', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

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

  return (
    <React.Fragment>
      <SegmentList
        segments={props.segments}
        segmentTotal={props.segmentTotal}
        deleteSegmentBegin={props.deleteSegmentBegin}
        handlePagination={handlePagination}
      />
    </React.Fragment>
  );
}

SegmentListPage.propTypes = {
  getSegmentsBegin: PropTypes.func.isRequired,
  segmentUnmount: PropTypes.func.isRequired,
  segments: PropTypes.object,
  segmentTotal: PropTypes.number,
  deleteSegmentBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  segments: selectPaginatedSegments(),
  segmentTotal: selectSegmentTotal(),
});

const mapDispatchToProps = {
  getSegmentsBegin,
  segmentUnmount,
  deleteSegmentBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SegmentListPage);
