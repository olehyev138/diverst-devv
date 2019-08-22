import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/reducer';
import saga from 'containers/Analyze/saga';

import {
  getGroupPopulationBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectGroupPopulation
} from 'containers/Analyze/selectors';

import RouteService from 'utils/routeHelpers';

import GroupPopulationGraph from 'components/Analyze/Graphs/GroupPopulationGraph';

export function GroupPopulationGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  console.log(props);

  useEffect(() => {
    props.getGroupPopulationBegin();
  }, []);

  return (
    <React.Fragment>
      <GroupPopulationGraph />
    </React.Fragment>
  );
}

GroupPopulationGraphPage.propTypes = {
  getGroupPopulationBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectGroupPopulation()
});

const mapDispatchToProps = {
  getGroupPopulationBegin,
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
