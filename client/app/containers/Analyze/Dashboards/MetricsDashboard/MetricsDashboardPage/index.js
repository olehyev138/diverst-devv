import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectMetricsDashboard } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';

import {
  getMetricsDashboardBegin, deleteMetricsDashboardBegin, metricsDashboardsUnmount
} from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

import MetricsDashboard from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboard';

export function MetricsDashboardPage(props) {
  useInjectReducer({ key: 'metrics_dashboards', reducer });
  useInjectSaga({ key: 'metrics_dashboards', saga });

  const rs = new RouteService(useContext);
  const links = {
    metrics_dashboardsIndex: ROUTES.group.custom.index.path(rs.params('group_id')),
    metrics_dashboardEdit: ROUTES.group.custom.edit.path(rs.params('group_id'), rs.params('metrics_dashboard_id'))
  };

  useEffect(() => {
    const metricsDashboardId = rs.params('metrics_dashboard_id');

    // get metrics_dashboard specified in path
    // props.getMetricsDashboardBegin({ id: metrics_dashboard_id });

    return () => props.metrics_dashboardsUnmount();
  }, []);

  const { currentUser, currentMetricsDashboard } = props;

  return (
    <MetricsDashboard
      currentUserId={currentUser.id}
      deleteMetricsDashboardBegin={props.deleteMetricsDashboardBegin}
      metrics_dashboard={currentMetricsDashboard}
      links={links}
    />
  );
}

MetricsDashboardPage.propTypes = {
  getMetricsDashboardBegin: PropTypes.func,
  deleteMetricsDashboardBegin: PropTypes.func,
  metrics_dashboardsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentMetricsDashboard: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentMetricsDashboard: selectMetricsDashboard(),
});

const mapDispatchToProps = {
  getMetricsDashboardBegin,
  deleteMetricsDashboardBegin,
  metrics_dashboardsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(MetricsDashboardPage);
