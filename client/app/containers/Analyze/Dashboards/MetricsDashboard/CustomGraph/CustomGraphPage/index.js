import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { useParams } from 'react-router-dom';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

import { getCustomGraphDataBegin, deleteCustomGraphBegin, customGraphUnmount } from '../actions';
import { selectCustomGraphData } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';

import { getUpdateRange } from 'utils/metricsHelpers';
import CustomGraph from 'components/Analyze/Graphs/Base/CustomGraph';

export function CustomGraphPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectSaga({ key: 'customMetrics', saga });

  const { metrics_dashboard_id: metricsDashboardId } = useParams();
  const links = {
    customGraphEdit: graphId => ROUTES.admin.analyze.custom.graphs.edit.path(metricsDashboardId, graphId)
  };

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
    props.getCustomGraphDataBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <CustomGraph
        customGraph={customGraph}
        data={props.selectData(customGraph.id)}
        updateRange={getUpdateRange([params, setParams])}
        deleteCustomGraphBegin={props.deleteCustomGraphBegin}
        links={links}
      />
    </React.Fragment>
  );
}

CustomGraphPage.propTypes = {
  customGraph: PropTypes.object.isRequired,
  selectData: PropTypes.func,
  getCustomGraphDataBegin: PropTypes.func,
  deleteCustomGraphBegin: PropTypes.func,
  customGraphUnmount: PropTypes.func
};

const mapStateToProps = state => ({
  selectData: id => selectCustomGraphData(id)(state)
});

const mapDispatchToProps = {
  getCustomGraphDataBegin,
  deleteCustomGraphBegin,
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
