import React, {
  memo, useEffect, useState, useContext
} from 'react';
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
  getMetricsDashboardBegin, updateMetricsDashboardBegin,
  metricsDashboardsUnmount
} from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

import MetricsDashboardForm from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardForm';

export function MetricsDashboardEditPage(props) {
  useInjectReducer({ key: 'metrics_dashboards', reducer });
  useInjectSaga({ key: 'metrics_dashboards', saga });

  const rs = new RouteService(useContext);
  const links = {
    metricsDashboardsIndex: ROUTES.group.metricsDashboards.index.path(rs.params('group_id')),
    metricsDashboardShow: ROUTES.group.metricsDashboards.show.path(rs.params('group_id'), rs.params('metricsDashboard_id')),
  };

  useEffect(() => {
    const metricsDashboardId = rs.params('metricsDashboard_id');
    props.getMetricsDashboardBegin({ id: metricsDashboardId });

    return () => props.metricsDashboardsUnmount();
  }, []);

  const { currentUser, currentGroup, currentMetricsDashboard } = props;

  return (
    <MetricsDashboardForm
      metricsDashboardAction={props.updateMetricsDashboardBegin}
      buttonText='Update'
      currentUser={currentUser}
      currentGroup={currentGroup}
      metricsDashboard={currentMetricsDashboard}
      links={links}
    />
  );
}

MetricsDashboardEditPage.propTypes = {
  getMetricsDashboardBegin: PropTypes.func,
  updateMetricsDashboardBegin: PropTypes.func,
  metricsDashboardsUnmount: PropTypes.func,
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
  updateMetricsDashboardBegin,
  metricsDashboardsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(MetricsDashboardEditPage);
