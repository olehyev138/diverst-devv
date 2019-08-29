import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { createMetricsDashboardBegin, metricsDashboardsUnmount } from 'containers/Analyze/Dashboards/MetricsDashboard/actions';
import MetricsDashboardForm from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardForm';

export function MetricsDashboardCreatePage(props) {
  useInjectReducer({ key: 'metrics_dashboards', reducer });
  useInjectSaga({ key: 'metrics_dashboards', saga });

  const { currentUser, currentGroup } = props;
  const rs = new RouteService(useContext);
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(),
  };

  useEffect(() => () => props.metricsDashboardsUnmount(), []);

  return (
    <MetricsDashboardForm
      metricsDashboardAction={props.createMetricsDashboardBegin}
      buttonText='Create'
      currentUser={currentUser}
      currentGroup={currentGroup}
      links={links}
    />
  );
}

MetricsDashboardCreatePage.propTypes = {
  createMetricsDashboardBegin: PropTypes.func,
  metricsDashboardsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser()
});

const mapDispatchToProps = {
  createMetricsDashboardBegin,
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
