/**
 *
 * MetricsPage
 *
 *  - lists all enterprise custom metrics
 *  - renders forms for creating & editing custom metrics
 *
 *  - function:
 *    - get metrics from server
 *    - on edit - render respective form with update data
 *    - on new - render respective empty form
 *    - on save - create/update update
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import dig from 'object-dig';

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectPaginatedMetrics,
  selectMetricsTotal,
  selectIsFetchingMetrics,
  selectHasChanged,
} from 'containers/Shared/Update/selectors';
import {
  getMetricsBegin,
  deleteUpdateBegin,
  updatesUnmount,
} from 'containers/Shared/Update/actions';

import reducer from 'containers/Shared/Update/reducer';
import saga from '../updatesSaga';

import { selectGroup } from 'containers/Group/selectors';
import KPI from 'components/Group/GroupPlan/KPIMetrics';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function KPIPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  const [params, setParams] = useState(
    {
      count: 5,
      page: 0,
      groupId: dig(props, 'currentGroup', 'id'),
    }
  );

  useEffect(() => {
    props.getMetricsBegin(params);

    return () => {
      props.updatesUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getMetricsBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment />
  );
}

KPIPage.propTypes = {
  getMetricsBegin: PropTypes.func.isRequired,
  deleteUpdateBegin: PropTypes.func,
  updatesUnmount: PropTypes.func.isRequired,

  metrics: PropTypes.array,
  total: PropTypes.number,
  isFetching: PropTypes.bool,
  hasChanged: PropTypes.bool,

  currentGroup: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  metrics: selectPaginatedMetrics(),
  total: selectMetricsTotal(),
  isFetching: selectIsFetchingMetrics(),
  hasChanged: selectHasChanged(),
  currentGroup: selectGroup(),
});

const mapDispatchToProps = {
  getMetricsBegin,
  deleteUpdateBegin,
  updatesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(KPIPage);
