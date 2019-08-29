import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_METRICS_DASHBOARDS_BEGIN, GET_METRICS_DASHBOARD_BEGIN,
  CREATE_METRICS_DASHBOARD_BEGIN, UPDATE_METRICS_DASHBOARD_BEGIN,
  DELETE_METRICS_DASHBOARD_BEGIN,
} from 'containers/Analyze/Dashboards/MetricsDashboard/constants';

import {
  getMetricsDashboardsSuccess, getMetricsDashboardsError,
  getMetricsDashboardSuccess, getMetricsDashboardError,
  createMetricsDashboardSuccess, createMetricsDashboardError,
  updateMetricsDashboardSuccess, updateMetricsDashboardError,
  deleteMetricsDashboardError,
} from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getMetricsDashboards(action) {
  try {
    const response = yield call(api.metrics.metricsDashboards.all.bind(api.metrics.metricsDashboards), action.payload);

    yield (put(getMetricsDashboardsSuccess(response.data.page)));
  } catch (err) {
    yield put(getMetricsDashboardsError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to load metrics_dashboards',
      options: { variant: 'warning' }
    }));
  }
}

export function* getMetricsDashboard(action) {
  try {
    const response = yield call(api.metrics.metricsDashboards.get.bind(api.metrics.metricsDashboards), action.payload.id);
    yield put(getMetricsDashboardSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getMetricsDashboardError(err));
    yield put(showSnackbar({
      message: 'Failed to get metrics_dashboard',
      options: { variant: 'warning' }
    }));
  }
}

export function* createMetricsDashboard(action) {
  try {
    const payload = { metricsDashboard: action.payload };

    const response = yield call(api.metrics.metricsDashboards.create.bind(api.metrics.metricsDashboards), payload);

    // yield put(push(ROUTES.group.metrics_dashboards.index.path(payload.metricsDashboard.group_id)));
    yield put(showSnackbar({
      message: 'Metrics dashboard created',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createMetricsDashboardError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to create metrics_dashboard',
      options: { variant: 'warning' }
    }));
  }
}

export function* updateMetricsDashboard(action) {
  try {
    const payload = { metricsDashboard: action.payload };
    const response = yield call(api.metrics.metricsDashboards.update.bind(api.metrics.metricsDashboards),
      payload.metricsDashboard.id, payload);

    // yield put(push(ROUTES.group.metrics_dashboards.index.path(payload.metricsDashboard.owner_group_id)));
    yield put(showSnackbar({
      message: 'Metrics dashboard updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateMetricsDashboardError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update metrics dashboard',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteMetricsDashboard(action) {
  try {
    yield call(api.metrics.metricsDashboards.destroy.bind(api.metrics.metricsDashboards), action.payload.id);
    yield put(push(ROUTES.group.metrics_dashboards.index.path(action.payload.group_id)));
    yield put(showSnackbar({
      message: 'Metrics dashboard deleted',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteMetricsDashboardError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to delete metrics dashboard',
      options: { variant: 'warning' }
    }));
  }
}

export default function* metricsDashboardsSaga() {
  yield takeLatest(GET_METRICS_DASHBOARDS_BEGIN, getMetricsDashboards);
  yield takeLatest(GET_METRICS_DASHBOARD_BEGIN, getMetricsDashboard);
  yield takeLatest(CREATE_METRICS_DASHBOARD_BEGIN, createMetricsDashboard);
  yield takeLatest(UPDATE_METRICS_DASHBOARD_BEGIN, updateMetricsDashboard);
  yield takeLatest(DELETE_METRICS_DASHBOARD_BEGIN, deleteMetricsDashboard);
}
