import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  getGroupPopulationBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectGroupPopulation
} from 'containers/Analyze/selectors';

import GroupPopulationGraph from 'components/Analyze/Graphs/GroupPopulationGraph';

export function GroupPopulationGraphPage(props) {
  useEffect(() => {
  }, []);

  return (
    <React.Fragment>
      <GroupPopulationGraph />
    </React.Fragment>
  );
}

GroupPopulationGraphPage.propTypes = {
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
)(GroupPopulationGraphPage);
