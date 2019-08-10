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

import { selectSegment, selectSegmentRules } from 'containers/Segment/selectors';
import {
  getSegmentBegin, createSegmentBegin,
  updateSegmentBegin, segmentUnmount
} from 'containers/Segment/actions';

import SegmentForm from 'components/Segment/SegmentForm';
import SegmentRulesForm from 'components/Segment/SegmentRulesForm';

export function SegmentEditPage(props) {
  useInjectReducer({ key: 'segments', reducer });
  useInjectSaga({ key: 'segments', saga });

  const rs = new RouteService(useContext);
  const segmentId = rs.params('segment_id');

  useEffect(() => {
    if (segmentId[0])
      props.getSegmentBegin({ id: rs.params('segment_id') });

    return () => {
      props.segmentUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <SegmentForm
        segmentAction={segmentId[0] ? props.updateSegmentBegin : props.createSegmentBegin}
        segment={props.segment}
        buttonText={segmentId[0] ? 'Update' : 'Create'}
      />
      <SegmentRulesForm
        rules={props.rules}
      />
    </React.Fragment>
  );
}

SegmentEditPage.propTypes = {
  segment: PropTypes.object,
  getSegmentBegin: PropTypes.func,
  createSegmentBegin: PropTypes.func,
  updateSegmentBegin: PropTypes.func,
  segmentUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  segment: selectSegment(),
  rules: selectSegmentRules()
});

const mapDispatchToProps = {
  getSegmentBegin,
  createSegmentBegin,
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
