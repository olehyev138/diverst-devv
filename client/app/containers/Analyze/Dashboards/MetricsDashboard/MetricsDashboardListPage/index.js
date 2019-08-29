import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Analyze/Dashboards/MetricsDashboard/reducer';
import saga from 'containers/Analyze/Dashboards/MetricsDashboard/saga';

import { selectPaginatedMetricsDashboards, selectMetricsDashboardsTotal } from 'containers/Analyze/Dashboards/MetricsDashboard/selectors';
import { getMetricsDashboardsBegin, metricsDashboardsUnmount } from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import MetricsDashboardsList from 'components/Analyze/Dashboards/MetricsDashboard/MetricsDashboardsList';

const MetricsDashboardTypes = Object.freeze({
  upcoming: 0,
  ongoing: 1,
  past: 2,
});

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in MetricsDashboardsList
  page: 0,
  order: 'desc',
  orderBy: 'start',
});

export function MetricsDashboardsPage(props) {
  useInjectReducer({ key: 'metrics_dashboards', reducer });
  useInjectSaga({ key: 'metrics_dashboards', saga });

  const rs = new RouteService(useContext);
  const links = {
    metricsDashboardsIndex: ROUTES.group.metricsDashboards.index.path(rs.params('group_id')),
    metricsDashboardShow: id => ROUTES.group.metricsDashboards.show.path(rs.params('group_id'), id),
    metricsDashboardNew: ROUTES.group.metricsDashboards.new.path(rs.params('group_id')),
    metricsDashboardEdit: id => ROUTES.group.metricsDashboards.edit.path(rs.params('group_id'), id)
  };

  const [tab, setTab] = useState(MetricsDashboardTypes.upcoming);
  const [params, setParams] = useState(defaultParams);

  const getMetricsDashboards = (scopes, resetParams = false) => {
    const id = dig(props, 'currentGroup', 'id');

    if (resetParams)
      setParams(defaultParams);

    if (id) {
      const newParams = {
        ...params,
        group_id: id,
        query_scopes: scopes
      };
      props.getMetricsDashboardsBegin(newParams);
      setParams(newParams);
    }
  };

  useEffect(() => {
    getMetricsDashboards(['upcoming']);

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
      currentTab={tab}
      handlePagination={handlePagination}
      links={links}
    />
  );
}

MetricsDashboardsPage.propTypes = {
  getMetricsDashboardsBegin: PropTypes.func.isRequired,
  metricsDashboardsUnmount: PropTypes.func.isRequired,
  metricsDashboards: PropTypes.array,
  metricsDashboardsTotal: PropTypes.number,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
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
)(MetricsDashboardsPage);
