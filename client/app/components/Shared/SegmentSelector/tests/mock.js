// mock store for segment selector
import React from 'react';
import SegmentSelector from '../index';
import PropTypes from 'prop-types';

function MockSegmentSelector(props) {
  return (
    <div>
      <SegmentSelector {...props} />
    </div>
  );
}

MockSegmentSelector.propTypes = {
  segmentField: PropTypes.string.isRequired,
  label: PropTypes.node.isRequired,
  handleChange: PropTypes.func.isRequired,
  setFieldValue: PropTypes.func.isRequired,
  values: PropTypes.object.isRequired,

  getSegmentsBegin: PropTypes.func.isRequired,
  segments: PropTypes.array,
  isLoading: PropTypes.bool,
};

export default MockSegmentSelector;
