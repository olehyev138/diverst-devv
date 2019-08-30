import React, { memo, useEffect, useContext } from 'react';
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
import { createMetricsDashboardBegin, metricsDashboardsUnmount } from 'containers/Analyze/Dashboards/MetricsDashboard/actions';
import { getGroupsBegin } from 'containers/Group/actions';
import { getSegmentsBegin } from 'containers/Segment/actions';

// selectors
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';
import { selectPaginatedSelectSegments } from 'containers/Segment/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import MetricsDashboardForm from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardForm';

export function MetricsDashboardCreatePage(props) {
  useInjectReducer({ key: 'metrics_dashboards', reducer });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectReducer({ key: 'segments', reducer: segmentReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });
  useInjectSaga({ key: 'segments', saga: segmentSaga });
  useInjectSaga({ key: 'metrics_dashboards', saga });

  const rs = new RouteService(useContext);
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(),
  };

  useEffect(() => () => props.metricsDashboardsUnmount(), []);

  return (
    <MetricsDashboardForm
      metricsDashboardAction={props.createMetricsDashboardBegin}
      getGroupsBegin={props.getGroupsBegin}
      getSegmentsBegin={props.getSegmentsBegin}
      groups={props.groups}
      segments={props.segments}
      buttonText='Create'
      links={links}
    />
  );
}

MetricsDashboardCreatePage.propTypes = {
  createMetricsDashboardBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  getSegmentsBegin: PropTypes.func,
  groups: PropTypes.array,
  segments: PropTypes.array,
  metricsDashboardsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
  segments: selectPaginatedSelectSegments()
});

const mapDispatchToProps = {
  createMetricsDashboardBegin,
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
)(MetricsDashboardCreatePage);
