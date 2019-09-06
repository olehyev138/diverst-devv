import React, {memo, useContext, useEffect, useRef, useState} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

import { getCustomGraphDataBegin, deleteCustomGraphBegin, customGraphUnmount } from '../actions';
import { selectCustomAggGraphData } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';

// helpers
import { getUpdateRange } from 'utils/metricsHelpers';
import CustomGraph from 'components/Analyze/Graphs/Base/CustomGraph';

export function CustomGraphPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectSaga({ key: 'customMetrics', saga });

  const rs = new RouteService(useContext);
  const links = {
    customGraphEdit: graphId => ROUTES.admin.analyze.custom.graphs.edit.path(rs.params('metrics_dashboard_id'), graphId)
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
    setCurrentData(props.data);
  }, [props.data]);

  useEffect(() => {
    props.getCustomGraphDataBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <CustomGraph
        customGraph={customGraph}
        data={currentData}
        updateRange={getUpdateRange([params, setParams])}
        deleteCustomGraphBegin={props.deleteCustomGraphBegin}
        links={links}
      />
    </React.Fragment>
  );
}

CustomGraphPage.propTypes = {
  customGraph: PropTypes.object.isRequired,
  data: PropTypes.array,
  getCustomGraphDataBegin: PropTypes.func,
  deleteCustomGraphBegin: PropTypes.func,
  customGraphUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectCustomAggGraphData()
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
