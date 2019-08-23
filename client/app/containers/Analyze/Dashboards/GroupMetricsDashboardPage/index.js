import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { metricsUnmount } from 'containers/Analyze/actions';

import GroupPopulationGraphPage from 'containers/Analyze/Graphs/GroupPopulationGraphPage';
import GrowthOfGroupsGraphPage from 'containers/Analyze/Graphs/GrowthOfGroupsGraphPage';

export function GroupMetricsDashboardPage(props) {
  useEffect(() => {
    return () => {
      props.metricsUnmount();
    };
  }, []);

  return (
    <GroupPopulationGraphPage />
  );
}

GroupMetricsDashboardPage.propTypes = {
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMetricsDashboardPage);
