import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

import { selectPaginatedMetricsDashboards, selectMetricsDashboardsTotal } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { getMetricsDashboardsBegin, metricsDashboardsUnmount } from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import MetricsDashboardsList from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardList';

const defaultParams = Object.freeze({
  count: 10,
  page: 0,
  order: 'desc',
});

export function MetricsDashboardListPage(props) {
  useInjectReducer({ key: 'customMetrics', reducer });
  useInjectSaga({ key: 'customMetrics', saga });

  const rs = new RouteService(useContext);
  const links = {
    metricsDashboardsIndex: ROUTES.admin.analyze.custom.index.path(rs.params('group_id')),
    metricsDashboardShow: id => ROUTES.admin.analyze.custom.show.path(rs.params('group_id'), id),
    metricsDashboardNew: ROUTES.admin.analyze.custom.new.path(),
    metricsDashboardEdit: id => ROUTES.admin.analyze.custom.edit.path(rs.params('group_id'), id)
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
      handlePagination={handlePagination}
      links={links}
    />
  );
}

MetricsDashboardListPage.propTypes = {
  getMetricsDashboardsBegin: PropTypes.func.isRequired,
  metricsDashboardsUnmount: PropTypes.func.isRequired,
  metricsDashboards: PropTypes.array,
  metricsDashboardsTotal: PropTypes.number,
};

const mapStateToProps = createStructuredSelector({
  metricsDashboards: selectPaginatedMetricsDashboards(),
  metricsDashboardsTotal: selectMetricsDashboardsTotal(),
});

const mapDispatchToProps = {
  getMetricsDashboardsBegin,
  metricsDashboardsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(MetricsDashboardListPage);
