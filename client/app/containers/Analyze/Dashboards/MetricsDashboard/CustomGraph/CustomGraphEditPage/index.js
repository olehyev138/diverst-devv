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
import fieldReducer from 'containers/Shared/Field/reducer';
import fieldSaga from 'containers/GlobalSettings/Field/saga';

// actions
import {
  getCustomGraphBegin, updateCustomGraphBegin, customGraphUnmount
} from '../actions';
import { getFieldsBegin } from 'containers/Shared/Field/actions';

// selectors
import { selectFormCustomGraph, selectIsCommitting, selectIsFormLoading } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { selectPaginatedSelectFields } from 'containers/Shared/Field/selectors';
import { selectEnterprise } from 'containers/Shared/App/selectors';

import { ROUTES } from 'containers/Shared/Routes/constants';
import CustomGraphForm from 'components/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphForm';

// messages
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function CustomGraphEditPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectReducer({ key: 'fields', reducer: fieldReducer });
  useInjectSaga({ key: 'customMetrics', saga });
  useInjectSaga({ key: 'fields', saga: fieldSaga });

  const { metrics_dashboard_id: metricsDashboardId, graph_id: graphId } = useParams();
  const links = {
    metricsDashboardShow: ROUTES.admin.analyze.custom.show.path(metricsDashboardId),
  };
  const { intl } = props;

  useEffect(() => {
    props.getCustomGraphBegin({ id: graphId });

    return () => props.customGraphUnmount();
  }, []);

  return (
    <CustomGraphForm
      edit
      customGraphAction={props.updateCustomGraphBegin}
      getFieldsBegin={props.getFieldsBegin}
      fields={props.fields}
      buttonText={intl.formatMessage(messages.update)}
      customGraph={props.currentCustomGraph}
      currentEnterprise={props.currentEnterprise}
      metricsDashboardId={metricsDashboardId}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

CustomGraphEditPage.propTypes = {
  intl: intlShape,
  getCustomGraphBegin: PropTypes.func,
  updateCustomGraphBegin: PropTypes.func,
  currentCustomGraph: PropTypes.object,
  getFieldsBegin: PropTypes.func,
  fields: PropTypes.array,
  customGraphUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  currentEnterprise: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentCustomGraph: selectFormCustomGraph(),
  fields: selectPaginatedSelectFields(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
  currentEnterprise: selectEnterprise()
});

const mapDispatchToProps = {
  getCustomGraphBegin,
  updateCustomGraphBegin,
  getFieldsBegin,
  customGraphUnmount
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
  CustomGraphEditPage,
  ['currentCustomGraph.permissions.update?', 'isFormLoading'],
  (props, params) => ROUTES.admin.analyze.custom.show.path(params.metrics_dashboard_id),
  permissionMessages.analyze.dashboards.metricsDashboard.customGraph.editPage
));
