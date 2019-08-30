import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

// reducers & sagas
import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';
import groupSaga from 'containers/Group/saga';
import groupReducer from 'containers/Group/reducer';
import segmentSaga from 'containers/Segment/saga';
import segmentReducer from 'containers/Segment/reducer';

// actions
import { getGroupsBegin } from 'containers/Group/actions';
import { getSegmentsBegin } from 'containers/Segment/actions';
import {
  getMetricsDashboardBegin, updateMetricsDashboardBegin,
  metricsDashboardsUnmount
} from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

// selectors
import { selectMetricsDashboard } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';
import { selectPaginatedSelectSegments } from 'containers/Segment/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import MetricsDashboardForm from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardForm';

export function MetricsDashboardEditPage(props) {
  useInjectReducer({ key: 'metrics_dashboards', reducer });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectReducer({ key: 'segments', reducer: segmentReducer });
  useInjectSaga({ key: 'metrics_dashboards', saga });
  useInjectSaga({ key: 'groups', saga: groupSaga });
  useInjectSaga({ key: 'segments', saga: segmentSaga });

  const rs = new RouteService(useContext);
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(),
    metricsDashboardShow: ROUTES.admin.analyze.custom.show.path()
  };

  useEffect(() => {
    const metricsDashboardId = rs.params('metrics_dashboard_id');
    props.getMetricsDashboardBegin({ id: metricsDashboardId });

    return () => props.metricsDashboardsUnmount();
  }, []);

  return (
    <MetricsDashboardForm
      metricsDashboardAction={props.updateMetricsDashboardBegin}
      getGroupsBegin={props.getGroupsBegin}
      getSegmentsBegin={props.getSegmentsBegin}
      groups={props.groups}
      segments={props.segments}
      buttonText='Update'
      metricsDashboard={props.currentMetricsDashboard}
      links={links}
    />
  );
}

MetricsDashboardEditPage.propTypes = {
  getMetricsDashboardBegin: PropTypes.func,
  updateMetricsDashboardBegin: PropTypes.func,
  metricsDashboardsUnmount: PropTypes.func,
  currentMetricsDashboard: PropTypes.object,
  getGroupsBegin: PropTypes.func,
  getSegmentsBegin: PropTypes.func,
  groups: PropTypes.array,
  segments: PropTypes.array,
};

const mapStateToProps = createStructuredSelector({
  currentMetricsDashboard: selectMetricsDashboard(),
  groups: selectPaginatedSelectGroups(),
  segments: selectPaginatedSelectSegments()
});

const mapDispatchToProps = {
  getMetricsDashboardBegin,
  updateMetricsDashboardBegin,
  getGroupsBegin,
  getSegmentsBegin,
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
