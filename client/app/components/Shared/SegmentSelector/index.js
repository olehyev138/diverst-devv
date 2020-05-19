/**
 *
 * SegmentSelector
 *
 */

import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';

import {
  getSegmentsBegin, segmentUnmount
} from 'containers/Segment/actions';

import { compose } from 'redux';
import { connect } from 'react-redux';

import DiverstSelect from '../DiverstSelect';
import { createStructuredSelector } from 'reselect';
import { selectIsLoading, selectPaginatedSelectSegments } from 'containers/Segment/selectors';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Segment/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Segment/saga';
import { permission } from 'utils/permissionsHelpers';
import { selectPermissions } from 'containers/Shared/App/selectors';

const SegmentSelector = ({ handleChange, values, segmentField, setFieldValue, label, ...rest }) => {
  useInjectReducer({ key: 'segments', reducer });
  useInjectSaga({ key: 'segments', saga });

  const { getSegmentsBegin, segmentUnmount, ...selectProps } = rest;

  const segmentSelectAction = (searchKey = '') => {
    rest.getSegmentsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  useEffect(() => {
    if (permission(rest, 'segments_view'))
      segmentSelectAction();

    return () => segmentUnmount();
  }, []);

  return (
    permission(rest, 'segments_view')
    && (
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
        onChange={value => setFieldValue(segmentField, value || (selectProps.isMulti ? [] : null))}
        onInputChange={value => segmentSelectAction(value)}
        hideHelperText
        {...selectProps}
      />
    )
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
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getSegmentsBegin,
  segmentUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(SegmentSelector);
