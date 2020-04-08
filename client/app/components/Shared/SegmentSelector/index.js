/**
 *
 * SegmentSelector
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';

import {
  getSegmentsBegin
} from 'containers/Segment/actions';

import { compose } from 'redux';
import { connect } from 'react-redux';

import DiverstSelect from '../DiverstSelect';
import { createStructuredSelector } from 'reselect';
import { selectPaginatedSelectSegments, selectIsLoading } from 'containers/Segment/selectors';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Segment/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Segment/saga';

const SegmentSelector = ({ handleChange, values, segmentField, setFieldValue, label, ...rest }) => {
  useInjectReducer({ key: 'segments', reducer });
  useInjectSaga({ key: 'segments', saga });

  const segmentSelectAction = (searchKey = '') => {
    rest.getSegmentsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  return (
    <DiverstSelect
      name={segmentField}
      id={segmentField}
      margin='normal'
      label={label}
      isMulti
      fullWidth
      isLoading={rest.isLoading}
      options={rest.segments}
      value={values[segmentField]}
      onChange={value => setFieldValue(segmentField, value)}
      onInputChange={value => segmentSelectAction(value)}
      hideHelperText
      {...rest}
    />
  );
};

SegmentSelector.propTypes = {
  segmentField: PropTypes.string.isRequired,
  label: PropTypes.node.isRequired,
  handleChange: PropTypes.func.isRequired,
  setFieldValue: PropTypes.func.isRequired,
  values: PropTypes.object.isRequired,

  getSegmentsBegin: PropTypes.func.isRequired,
  segments: PropTypes.array,
  isLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  segments: selectPaginatedSelectSegments(),
  isLoading: selectIsLoading(),
});

const mapDispatchToProps = {
  getSegmentsBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SegmentSelector);
