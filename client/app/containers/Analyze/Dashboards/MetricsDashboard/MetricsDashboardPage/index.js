import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { useParams } from 'react-router-dom';

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
import permissionMessages from 'containers/Shared/Permissions/messages';

export function MetricsDashboardPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectSaga({ key: 'customMetrics', saga });

  const { metrics_dashboard_id: metricsDashboardId } = useParams();
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(),
    metricsDashboardEdit: ROUTES.admin.analyze.custom.edit.path(metricsDashboardId),
    customGraphNew: ROUTES.admin.analyze.custom.graphs.new.path(metricsDashboardId),
  };

  useEffect(() => {
    // get metrics_dashboard specified in path
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
  (props, params) => ROUTES.admin.analyze.custom.index.path(),
  permissionMessages.analyze.dashboards.metricsDashboard.showPage
));
