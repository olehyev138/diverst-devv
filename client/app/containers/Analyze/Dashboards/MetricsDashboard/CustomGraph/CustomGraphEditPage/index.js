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
import fieldReducer from 'containers/GlobalSettings/Field/reducer';
import fieldSaga from 'containers/GlobalSettings/Field/saga';

// actions
import {
  getCustomGraphBegin, updateCustomGraphBegin, customGraphUnmount
} from '../actions';
import { getFieldsBegin } from 'containers/GlobalSettings/Field/actions';

// selectors
import { selectFormCustomGraph, selectIsCommitting, selectIsFormLoading } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { selectPaginatedSelectFields } from 'containers/GlobalSettings/Field/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import CustomGraphForm from 'components/Analyze/Dashboards/MetricsDashboard/CustomGraph/CustomGraphForm';

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
      buttonText='Update'
      customGraph={props.currentCustomGraph}
      metricsDashboardId={metricsDashboardId[0]}
      links={links}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
    />
  );
}

CustomGraphEditPage.propTypes = {
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
  withConnect,
  memo,
)(CustomGraphEditPage);
