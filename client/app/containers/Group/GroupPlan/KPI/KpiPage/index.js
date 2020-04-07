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

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectUpdatesTotal,
  selectHasChanged,
} from 'containers/Shared/Update/selectors';
import {
  deleteUpdateBegin,
  updatesUnmount,
} from 'containers/Shared/Update/actions';

import reducer from 'containers/Shared/Update/reducer';
import saga from '../updatesSaga';

import { selectGroup } from 'containers/Group/selectors';

import NotFoundPage from 'containers/Shared/NotFoundPage';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';

export function KPIPage(props) {
  useInjectReducer({ key: 'updates', reducer });
  useInjectSaga({ key: 'updates', saga });

  return (
    <NotFoundPage />
  );
}

KPIPage.propTypes = {
  getMetricsBegin: PropTypes.func.isRequired,
  deleteUpdateBegin: PropTypes.func,
  updatesUnmount: PropTypes.func.isRequired,

  metrics: PropTypes.object,
  total: PropTypes.number,
  isFetching: PropTypes.bool,
  hasChanged: PropTypes.bool,

  currentGroup: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  total: selectUpdatesTotal(),
  hasChanged: selectHasChanged(),
  currentGroup: selectGroup(),
});

const mapDispatchToProps = {
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
)(Conditional(
  KPIPage,
  ['currentGroup.permissions.kpi_manage?'],
  (props, rs) => ROUTES.group.plan.index.path(rs.params('group_id')),
  'group.groupPlan.KPI.kpiPage'
));
