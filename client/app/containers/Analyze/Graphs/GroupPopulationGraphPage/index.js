import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import dig from 'object-dig';

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

  // TEMP - swap x & y for horizontal
  const data = (dig(props.data, 'series', 0, 'values') || [{ x: '', y: 0 }]).map(d => ({ x: d.y, y: d.x }));

  useEffect(() => {
    props.getGroupPopulationBegin();
  }, []);

  return (
    <React.Fragment>
      <GroupPopulationGraph
        data={data}
      />
    </React.Fragment>
  );
}

GroupPopulationGraphPage.propTypes = {
  data: PropTypes.object,
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
