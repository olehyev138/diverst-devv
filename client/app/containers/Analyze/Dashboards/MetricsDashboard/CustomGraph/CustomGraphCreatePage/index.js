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
import fieldReducer from 'containers/Shared/Field/reducer';
import fieldSaga from 'containers/GlobalSettings/Field/saga';

// actions
import { createCustomGraphBegin, customGraphUnmount } from '../actions';
import { getFieldsBegin } from 'containers/Shared/Field/actions';

// selectors
import { selectIsCommitting } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { selectPaginatedSelectFields } from 'containers/Shared/Field/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import CustomGraphForm from 'components/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphForm';
import { selectEnterprise } from 'containers/Shared/App/selectors';
// messages
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/messages';
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

  useEffect(() => () => props.customGraphUnmount(), []);

  return (
    <CustomGraphForm
      customGraphAction={props.createCustomGraphBegin}
      getFieldsBegin={props.getFieldsBegin}
      fields={props.fields}
      metricsDashboardId={metricsDashboardId[0]}
      buttonText={<DiverstFormattedMessage {...messages.create} />}
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
  isCommitting: PropTypes.bool,
  currentEnterprise: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedSelectFields(),
  isCommitting: selectIsCommitting(),
  currentEnterprise: selectEnterprise(),
});

const mapDispatchToProps = {
  createCustomGraphBegin,
  getFieldsBegin,
  customGraphUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CustomGraphCreatePage);
