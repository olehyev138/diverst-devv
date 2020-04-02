import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

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

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import CustomGraphForm from 'components/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphForm';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';

// messages
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/messages';
import { injectIntl, intlShape } from 'react-intl';

export function CustomGraphCreatePage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectReducer({ key: 'fields', reducer: fieldReducer });
  useInjectSaga({ key: 'groups', saga: fieldSaga });
  useInjectSaga({ key: 'customMetrics', saga });

  const rs = new RouteService(useContext);
  const metricsDashboardId = rs.params('metrics_dashboard_id');
  const links = {
    metricsDashboardShow: ROUTES.admin.analyze.custom.show.path(metricsDashboardId),
  };
  const { intl } = props;

  useEffect(() => {
    // get metrics_dashboard specified in path
    const metricsDashboardId = rs.params('metrics_dashboard_id');
    props.getMetricsDashboardBegin({ id: metricsDashboardId });

    return () => props.metricsDashboardsUnmount();
  }, []);

  useEffect(() => () => props.customGraphUnmount(), []);

  return (
    <CustomGraphForm
      customGraphAction={props.createCustomGraphBegin}
      getFieldsBegin={props.getFieldsBegin}
      fields={props.fields}
      metricsDashboardId={metricsDashboardId}
      buttonText={intl.formatMessage(messages.create)}
      links={links}
      isCommitting={props.isCommitting}
    />
  );
}

CustomGraphCreatePage.propTypes = {
  intl: intlShape,
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
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  CustomGraphCreatePage,
  ['currentDashboard.permissions.update?', 'isLoading'],
  (props, rs) => ROUTES.admin.analyze.custom.show.path(rs.params('metrics_dashboard_id')),
  'You don\'t have permission to create a graph for this dashboard'
));
