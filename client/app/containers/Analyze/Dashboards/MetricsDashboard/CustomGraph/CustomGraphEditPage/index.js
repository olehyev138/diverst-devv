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

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import CustomGraphForm from 'components/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphForm';

// messages
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import { resolveRootManagePath } from 'utils/adminLinkHelpers';
import { CustomGraphCreatePage } from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphCreatePage';

export function CustomGraphEditPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectReducer({ key: 'fields', reducer: fieldReducer });
  useInjectSaga({ key: 'customMetrics', saga });
  useInjectSaga({ key: 'fields', saga: fieldSaga });

  const rs = new RouteService(useContext);
  const metricsDashboardId = rs.params('metrics_dashboard_id');
  const links = {
    metricsDashboardShow: ROUTES.admin.analyze.custom.show.path(metricsDashboardId),
  };
  const { intl } = props;

  useEffect(() => {
    const customGraphId = rs.params('graph_id');
    props.getCustomGraphBegin({ id: customGraphId });

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
      metricsDashboardId={metricsDashboardId[0]}
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
};

const mapStateToProps = createStructuredSelector({
  currentCustomGraph: selectFormCustomGraph(),
  fields: selectPaginatedSelectFields(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
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
  CustomGraphCreatePage,
  ['currentCustomGraph.permissions.update?', 'isFormLoading'],
  (props, rs) => resolveRootManagePath(props.permissions).path() || ROUTES.user.home.path(),
  'You don\'t have permission to update graph for this dashboard'
));
