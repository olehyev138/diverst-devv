import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Segment/saga';
import reducer from 'containers/Segment/reducer';

import groupSaga from 'containers/Group/saga';
import groupReducer from 'containers/Group/reducer';

import RouteService from 'utils/routeHelpers';

import { selectSegment, selectSegmentWithRules } from 'containers/Segment/selectors';
import {
  getSegmentBegin, createSegmentBegin,
  updateSegmentBegin, segmentUnmount
} from 'containers/Segment/actions';

import { getGroupsBegin } from 'containers/Group/actions';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';

import SegmentForm from 'components/Segment/SegmentForm';
import GroupForm from 'components/Group/GroupForm';

export function SegmentEditPage(props) {
  useInjectReducer({ key: 'segments', reducer });
  useInjectSaga({ key: 'segments', saga });
  useInjectSaga({ key: 'groups', saga: groupSaga });
  useInjectReducer({ key: 'groups', reducer: groupReducer });

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
        ruleProps={{
          getGroupsBegin: props.getGroupsBegin,
          groups: props.groups
        }}
        buttonText={segmentId[0] ? 'Update' : 'Create'}
      />
    </React.Fragment>
  );
}

SegmentEditPage.propTypes = {
  segment: PropTypes.object,
  rules: PropTypes.object,
  getSegmentBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groups: PropTypes.array,
  createSegmentBegin: PropTypes.func,
  updateSegmentBegin: PropTypes.func,
  segmentUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  segment: selectSegmentWithRules(),
  groups: selectPaginatedSelectGroups()
});

const mapDispatchToProps = {
  getSegmentBegin,
  createSegmentBegin,
  updateSegmentBegin,
  segmentUnmount,
  getGroupsBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SegmentEditPage);
