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
import { selectIsCommitting } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';
import { selectPaginatedSelectSegments } from 'containers/Segment/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import MetricsDashboardForm from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardForm';

// messages
import messages from 'containers/Analyze/messages';
import { injectIntl, intlShape } from 'react-intl';

export function MetricsDashboardCreatePage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectReducer({ key: 'segments', reducer: segmentReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });
  useInjectSaga({ key: 'segments', saga: segmentSaga });
  useInjectSaga({ key: 'customMetrics', saga });

  const rs = new RouteService(useContext);
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(),
  };
  const { intl } = props;

  useEffect(() => () => props.metricsDashboardsUnmount(), []);

  return (
    <MetricsDashboardForm
      metricsDashboardAction={props.createMetricsDashboardBegin}
      getGroupsBegin={props.getGroupsBegin}
      getSegmentsBegin={props.getSegmentsBegin}
      groups={props.groups}
      segments={props.segments}
      buttonText={intl.formatMessage(messages.create)}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

MetricsDashboardCreatePage.propTypes = {
  intl: intlShape,
  createMetricsDashboardBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  getSegmentsBegin: PropTypes.func,
  groups: PropTypes.array,
  segments: PropTypes.array,
  metricsDashboardsUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
  segments: selectPaginatedSelectSegments(),
  isCommitting: selectIsCommitting(),
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
  injectIntl,
  withConnect,
  memo,
)(MetricsDashboardCreatePage);
