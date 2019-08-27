import React, { memo, useEffect, useRef, useState } from 'react';
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

// helpers
import {
  getUpdateRange, getHandleDrilldown, formatBarGraphData
} from 'utils/metricsHelpers';

import GroupPopulationGraph from 'components/Analyze/Graphs/GroupPopulationGraph';

export function GroupPopulationGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  const [currentData, setCurrentData] = useState([]);
  const [isDrilldown, setIsDrilldown] = useState(false);
  const isInitalRender = useRef(true);

  const [params, setParams] = useState({
    date_range: {
      from_date: '',
      to_date: ''
    },
    scoped_by_models: props.dashboardParams.scoped_by_models
  });

  useEffect(() => {
    setCurrentData(props.data);
  }, [props.data]);

  useEffect(() => {
    if (isInitalRender.current)
      isInitalRender.current = false;
    else
      setParams({ ...params, scoped_by_models: props.dashboardParams.scoped_by_models });
  }, [props.dashboardParams]);

  useEffect(() => {
    props.getGroupPopulationBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <GroupPopulationGraph
        data={currentData}
        updateRange={getUpdateRange([params, setParams])}
        handleDrilldown={getHandleDrilldown([props.data, setCurrentData], [isDrilldown, setIsDrilldown])}
        isDrilldown={isDrilldown}
      />
    </React.Fragment>
  );
}

GroupPopulationGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardParams: PropTypes.object,
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
