import React, { memo, useEffect, useRef, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/reducer';
import saga from 'containers/Analyze/saga';

import {
  getGroupOverviewMetricsBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectGroupOverviewMetrics
} from 'containers/Analyze/selectors';

import GroupOverviewMetrics from 'components/Analyze/Metrics/GroupOverviewMetrics';

export function GroupOverviewMetricsPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  /**
   * Group overview metrics
   *   - displays metrics concerning an enterprises groups
   */

  useEffect(() => {
    props.getGroupOverviewMetricsBegin();

    return () => props.metricsUnmount();
  }, []);

  return (
    <React.Fragment>
      <GroupOverviewMetrics data={props.data} />
    </React.Fragment>
  );
}

GroupOverviewMetricsPage.propTypes = {
  data: PropTypes.object,
  getGroupOverviewMetricsBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectGroupOverviewMetrics()
});

const mapDispatchToProps = {
  getGroupOverviewMetricsBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupOverviewMetricsPage);
