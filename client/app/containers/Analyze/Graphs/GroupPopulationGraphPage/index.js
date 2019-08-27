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

import GroupPopulationGraph from 'components/Analyze/Graphs/GroupPopulationGraph';

export function GroupPopulationGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  const [data, setData] = useState([]);

  if (Object.keys(props.data).length > 0 && data.length <= 0) {
    // TEMP - swap x & y for horizontal
    setData((dig(props.data, 'series', 0, 'values') || [{ x: '', y: 0 }]).map(d => ({ x: d.y, y: d.x })));
  }

  const onDrilldown = ((datapoint) => {
    const children = props.data.series[0].values.find(s => s.x === datapoint.y).children;
    setData(children.values.map(d => ({ x: d.y, y: d.x })));
  });


  const [params, setParams] = useState({
    date_range: {
      from_date: '',
      to_date: ''
    },
    scoped_by_models: props.dashboardParams.scoped_by_models
  });

  const updateRange = (range) => {
    const newParams = { ...params, date_range: range };

    setParams(newParams);
  };

  if (params.scoped_by_models !== props.dashboardParams.scoped_by_models)
    setParams({ ...params, scoped_by_models: props.dashboardParams.scoped_by_models });

  useEffect(() => {
    props.getGroupPopulationBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <GroupPopulationGraph
        data={data}
        updateRange={updateRange}
        onDrilldown={onDrilldown}
      />
    </React.Fragment>
  );
}

GroupPopulationGraphPage.propTypes = {
  data: PropTypes.object,
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
