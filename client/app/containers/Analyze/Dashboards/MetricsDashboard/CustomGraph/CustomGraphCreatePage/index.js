import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import Conditional from 'components/Compositions/Conditional';

// reducers & sagas
import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';
import fieldReducer from 'containers/Shared/Field/reducer';
import fieldSaga from 'containers/GlobalSettings/Field/saga';

// actions
import { createCustomGraphBegin, customGraphUnmount } from '../actions';
import { getFieldsBegin } from 'containers/Shared/Field/actions';
import { getMetricsDashboardBegin, metricsDashboardsUnmount } from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

// selectors
import {
  selectIsCommitting,
  selectIsFormLoading,
  selectMetricsDashboard
} from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { selectPaginatedSelectFields } from 'containers/Shared/Field/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';

import CustomGraphForm from 'components/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphForm';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';

// messages
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';

import permissionMessages from 'containers/Shared/Permissions/messages';

export function CustomGraphCreatePage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectReducer({ key: 'fields', reducer: fieldReducer });
  useInjectSaga({ key: 'groups', saga: fieldSaga });
  useInjectSaga({ key: 'customMetrics', saga });

  const { metrics_dashboard_id: metricsDashboardId } = useParams();
  const links = {
    metricsDashboardShow: ROUTES.admin.analyze.custom.show.path(metricsDashboardId),
  };

  useEffect(() => {
    // get metrics_dashboard specified in path
    props.getMetricsDashboardBegin({ id: metricsDashboardId });

    return () => props.metricsDashboardsUnmount();
  }, []);

  useEffect(() => () => props.customGraphUnmount(), []);

  return (
    <CustomGraphForm
      customGraphAction={props.createCustomGraphBegin}
      getFieldsBegin={props.getFieldsBegin}
      fields={props.fields}
      metricsDashboardId={metricsDashboardId[0]}
      currentEnterprise={props.currentEnterprise}
      buttonText={messages.create}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

CustomGraphCreatePage.propTypes = {
  createCustomGraphBegin: PropTypes.func,
  getFieldsBegin: PropTypes.func,
  getSegmentsBegin: PropTypes.func,
  fields: PropTypes.array,
  segments: PropTypes.array,
  customGraphUnmount: PropTypes.func,
  getMetricsDashboardBegin: PropTypes.func,
  metricsDashboardsUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  currentEnterprise: PropTypes.object,
  currentDashboard: PropTypes.object,
  permissions: PropTypes.object,
  isLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedSelectFields(),
  isCommitting: selectIsCommitting(),
  currentEnterprise: selectEnterprise(),
  permissions: selectPermissions(),
  currentDashboard: selectMetricsDashboard(),
  isLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  createCustomGraphBegin,
  getFieldsBegin,
  customGraphUnmount,
  getMetricsDashboardBegin,
  metricsDashboardsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  CustomGraphCreatePage,
  ['currentDashboard.permissions.update?', 'isLoading'],
  (props, params) => ROUTES.admin.analyze.custom.show.path(params.metrics_dashboard_id),
  permissionMessages.analyze.dashboards.metricsDashboard.customGraph.createPage
));
