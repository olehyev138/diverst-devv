import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Segment/saga';
import reducer from 'containers/Segment/reducer';

import RouteService from 'utils/routeHelpers';

import { selectSegment } from 'containers/Segment/selectors';
import {
  getSegmentBegin, updateSegmentBegin,
  segmentUnmount
} from 'containers/Segment/actions';

import SegmentForm from 'components/Segment/SegmentForm';

export function SegmentEditPage(props) {
  useInjectReducer({ key: 'segments', reducer });
  useInjectSaga({ key: 'segments', saga });

  const rs = new RouteService(useContext);

  useEffect(() => {
    props.getSegmentBegin({ id: rs.params('segment_id') });

    return () => {
      props.segmentUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <SegmentForm
        segmentAction={props.updateSegmentBegin}
        segment={props.segment}
        buttonText='Save'
      />
    </React.Fragment>
  );
}

SegmentEditPage.propTypes = {
  segment: PropTypes.object,
  getSegmentBegin: PropTypes.func,
  updateSegmentBegin: PropTypes.func,
  segmentUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  segment: selectSegment(),
});

const mapDispatchToProps = {
  getSegmentBegin,
  updateSegmentBegin,
  segmentUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SegmentEditPage);
