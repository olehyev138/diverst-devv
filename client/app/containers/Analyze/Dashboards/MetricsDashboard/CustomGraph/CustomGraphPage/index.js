import React, { memo, useEffect, useRef, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

import { getCustomGraphDataBegin, customGraphUnmount } from '../actions';
import { selectCustomGraphData } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';

// helpers
import { getUpdateRange, formatBarGraphData } from 'utils/metricsHelpers';
import CustomGraph from 'components/Analyze/Graphs/Base/CustomGraph';

export function CustomGraphPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectSaga({ key: 'customMetrics', saga });

  const { customGraph } = props;
  const [currentData, setCurrentData] = useState([]);
  const [params, setParams] = useState({
    id: customGraph.id,
    date_range: {
      from_date: '',
      to_date: ''
    },
  });

  useEffect(() => {
    setCurrentData(props.data);
  }, [props.data]);

  useEffect(() => {
    props.getCustomGraphDataBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <CustomGraph
        data={currentData}
        updateRange={getUpdateRange([params, setParams])}
      />
    </React.Fragment>
  );
}

CustomGraphPage.propTypes = {
  customGraph: PropTypes.object.isRequired,
  data: PropTypes.array,
  getCustomGraphDataBegin: PropTypes.func,
  customGraphUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectCustomGraphData()
});

const mapDispatchToProps = {
  getCustomGraphDataBegin,
  customGraphUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CustomGraphPage);
