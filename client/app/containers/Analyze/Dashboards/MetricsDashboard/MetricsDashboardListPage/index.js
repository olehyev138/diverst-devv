import React, { memo, useEffect, useState } from 'react';
import { push } from 'connected-react-router';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { useParams } from 'react-router-dom';

// reducers & sagas
import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

// actions
import {
  getMetricsDashboardsBegin, deleteMetricsDashboardBegin, metricsDashboardsUnmount
} from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

// selectors
import {
  selectPaginatedMetricsDashboards, selectMetricsDashboardsTotal
} from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';

import MetricsDashboardsList from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardList';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions, selectCustomText } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

const defaultParams = Object.freeze({
  count: 10,
  page: 0,
  order: 'desc',
});

export function MetricsDashboardListPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectSaga({ key: 'customMetrics', saga });

  const { group_id: groupId } = useParams();
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(groupId),
    metricsDashboardShow: id => ROUTES.admin.analyze.custom.show.path(groupId, id),
    metricsDashboardNew: ROUTES.admin.analyze.custom.new.path(),
    metricsDashboardEdit: id => ROUTES.admin.analyze.custom.edit.path(groupId, id)
  };

  const [params, setParams] = useState(defaultParams);

  useEffect(() => {
    props.getMetricsDashboardsBegin();

    return () => {
      props.metricsDashboardsUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getMetricsDashboardsBegin(newParams);
    setParams(newParams);
  };

  return (
    <MetricsDashboardsList
      metricsDashboards={props.metricsDashboards}
      metricsDashboardsTotal={props.metricsDashboardsTotal}
      handleVisitDashboardPage={props.handleVisitDashboardPage}
      handleVisitDashboardEdit={props.handleVisitDashboardEdit}
      deleteMetricsDashboardBegin={props.deleteMetricsDashboardBegin}
      handlePagination={handlePagination}
      links={links}
      customTexts={props.customTexts}
    />
  );
}

MetricsDashboardListPage.propTypes = {
  getMetricsDashboardsBegin: PropTypes.func.isRequired,
  deleteMetricsDashboardBegin: PropTypes.func.isRequired,
  handleVisitDashboardPage: PropTypes.func.isRequired,
  handleVisitDashboardEdit: PropTypes.func.isRequired,
  metricsDashboardsUnmount: PropTypes.func.isRequired,
  metricsDashboards: PropTypes.array,
  metricsDashboardsTotal: PropTypes.number,
  permissions: PropTypes.object,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  metricsDashboards: selectPaginatedMetricsDashboards(),
  metricsDashboardsTotal: selectMetricsDashboardsTotal(),
  permissions: selectPermissions(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = dispatch => ({
  getMetricsDashboardsBegin: payload => dispatch(getMetricsDashboardsBegin(payload)),
  deleteMetricsDashboardBegin: payload => dispatch(deleteMetricsDashboardBegin(payload)),
  handleVisitDashboardPage: id => dispatch(push(ROUTES.admin.analyze.custom.show.path(id))),
  handleVisitDashboardEdit: id => dispatch(push(ROUTES.admin.analyze.custom.edit.path(id))),
  metricsDashboardsUnmount: () => dispatch(metricsDashboardsUnmount()),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  MetricsDashboardListPage,
  ['permissions.metrics_overview'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.analyze.dashboards.metricsDashboard.listPage
));
