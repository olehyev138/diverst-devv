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
  getGroupPopulationBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectGroupPopulation
} from 'containers/Analyze/selectors';

// helpers
import {
  filterData
} from 'utils/metricsHelpers';

import GroupPopulationGraph from 'components/Analyze/Graphs/GroupPopulationGraph';

export function GroupPopulationGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  /**
   * Group Population bar graph
   *  - implements no graph specific filtering
   *  - accepts dashboard filters
   */

  const [currentData, setCurrentData] = useState([]);

  useEffect(() => {
    setCurrentData(filterData(props.data, props.dashboardFilters).slice(0, 10));
  }, [props.data, props.dashboardFilters]);

  useEffect(() => {
    props.getGroupPopulationBegin();
  }, []);

  return (
    <React.Fragment>
      <GroupPopulationGraph
        data={currentData}
      />
    </React.Fragment>
  );
}

GroupPopulationGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardFilters: PropTypes.array,
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
