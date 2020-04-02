import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

// reducers & sagas
import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

// actions
import {
  getMetricsDashboardBegin, deleteMetricsDashboardBegin, metricsDashboardsUnmount
} from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

// selectors
import { selectMetricsDashboard, selectIsFormLoading } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';

import MetricsDashboard from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboard';
import Conditional from 'components/Compositions/Conditional';

export function MetricsDashboardPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectSaga({ key: 'customMetrics', saga });

  const rs = new RouteService(useContext);
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(),
    metricsDashboardEdit: ROUTES.admin.analyze.custom.edit.path(rs.params('metrics_dashboard_id')),
    customGraphNew: ROUTES.admin.analyze.custom.graphs.new.path(rs.params('metrics_dashboard_id')),
  };

  useEffect(() => {
    // get metrics_dashboard specified in path
    const metricsDashboardId = rs.params('metrics_dashboard_id');
    props.getMetricsDashboardBegin({ id: metricsDashboardId });

    return () => props.metricsDashboardsUnmount();
  }, []);

  return (
    <MetricsDashboard
      deleteMetricsDashboardBegin={props.deleteMetricsDashboardBegin}
      metricsDashboard={props.currentMetricsDashboard}
      links={links}
      isFormLoading={props.isFormLoading}
    />
  );
}

MetricsDashboardPage.propTypes = {
  getMetricsDashboardBegin: PropTypes.func,
  deleteMetricsDashboardBegin: PropTypes.func,
  metricsDashboardsUnmount: PropTypes.func,
  currentMetricsDashboard: PropTypes.object,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentMetricsDashboard: selectMetricsDashboard(),
  isFormLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  getMetricsDashboardBegin,
  deleteMetricsDashboardBegin,
  metricsDashboardsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  MetricsDashboardPage,
  ['currentMetricsDashboard.permissions.show?', 'isFormLoading'],
  (props, rs) => ROUTES.admin.analyze.custom.index.path(),
  'You don\'t have permission to create view this dashboard'
));
