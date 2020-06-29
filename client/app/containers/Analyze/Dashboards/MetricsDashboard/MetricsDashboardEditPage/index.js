import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

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
import { selectFormMetricsDashboard, selectIsCommitting, selectIsFormLoading } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';
import { selectPaginatedSelectSegments } from 'containers/Segment/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

import MetricsDashboardForm from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardForm';

// messages
import messages from 'containers/Analyze/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function MetricsDashboardEditPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectReducer({ key: 'segments', reducer: segmentReducer });
  useInjectSaga({ key: 'customMetrics', saga });
  useInjectSaga({ key: 'groups', saga: groupSaga });
  useInjectSaga({ key: 'segments', saga: segmentSaga });

  const { metrics_dashboard_id: metricsDashboardId } = useParams();
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(),
  };
  const { intl } = props;

  useEffect(() => {
    props.getMetricsDashboardBegin({ id: metricsDashboardId });

    return () => props.metricsDashboardsUnmount();
  }, []);

  return (
    <MetricsDashboardForm
      edit
      metricsDashboardAction={props.updateMetricsDashboardBegin}
      getGroupsBegin={props.getGroupsBegin}
      getSegmentsBegin={props.getSegmentsBegin}
      groups={props.groups}
      segments={props.segments}
      buttonText={intl.formatMessage(messages.update)}
      metricsDashboard={props.currentMetricsDashboard}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

MetricsDashboardEditPage.propTypes = {
  intl: intlShape.isRequired,
  getMetricsDashboardBegin: PropTypes.func,
  updateMetricsDashboardBegin: PropTypes.func,
  metricsDashboardsUnmount: PropTypes.func,
  currentMetricsDashboard: PropTypes.object,
  getGroupsBegin: PropTypes.func,
  getSegmentsBegin: PropTypes.func,
  groups: PropTypes.array,
  segments: PropTypes.array,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentMetricsDashboard: selectFormMetricsDashboard(),
  groups: selectPaginatedSelectGroups(),
  segments: selectPaginatedSelectSegments(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  MetricsDashboardEditPage,
  ['currentMetricsDashboard.permissions.show?', 'isFormLoading'],
  (props, params) => ROUTES.admin.analyze.custom.show.path(params.metrics_dashboard_id),
  permissionMessages.analyze.dashboards.metricsDashboard.editPage
));
