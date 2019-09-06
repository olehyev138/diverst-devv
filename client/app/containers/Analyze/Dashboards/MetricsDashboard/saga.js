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

import {
  GET_CUSTOM_GRAPH_BEGIN, CREATE_CUSTOM_GRAPH_BEGIN, UPDATE_CUSTOM_GRAPH_BEGIN,
  GET_CUSTOM_GRAPH_DATA_BEGIN, DELETE_CUSTOM_GRAPH_BEGIN,
} from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/constants';

import {
  getCustomGraphSuccess, getCustomGraphDataSuccess,
  createCustomGraphSuccess, createCustomGraphError,
  updateCustomGraphSuccess, updateCustomGraphError,
  deleteCustomGraphError,
} from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

/* Metrics Dashboard */

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
    const payload = { metrics_dashboard: action.payload };
    const response = yield call(api.metrics.metricsDashboards.create.bind(api.metrics.metricsDashboards), payload);

    yield put(push(ROUTES.admin.analyze.custom.index.path()));
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
    const payload = { metrics_dashboard: action.payload };
    const response = yield call(api.metrics.metricsDashboards.update.bind(api.metrics.metricsDashboards),
      payload.metrics_dashboard.id, payload);

    yield put(push(ROUTES.admin.analyze.custom.index.path()));
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
    yield call(api.metrics.metricsDashboards.destroy.bind(api.metrics.metricsDashboards), action.payload);
    yield put(push(ROUTES.admin.analyze.custom.index.path()));
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

/* Graphs */
export function* getCustomGraph(action) {
  try {
    const response = yield call(api.metrics.customGraphs.get.bind(api.metrics.customGraphs), action.payload.id);
    yield put(getCustomGraphSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getMetricsDashboardError(err));
    yield put(showSnackbar({
      message: 'Failed to get graph data',
      options: { variant: 'warning' }
    }));
  }
}

export function* getCustomGraphData(action) {
  try {
    const response = yield call(api.metrics.customGraphs.data.bind(api.metrics.customGraphs), { graph: action.payload });
    yield put(getCustomGraphDataSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getMetricsDashboardError(err));
    yield put(showSnackbar({
      message: 'Failed to get graph',
      options: { variant: 'warning' }
    }));
  }
}

export function* createCustomGraph(action) {
  try {
    const payload = { graph: action.payload };
    const response = yield call(api.metrics.customGraphs.create.bind(api.metrics.customGraphs), payload);

    yield put(push(ROUTES.admin.analyze.custom.show.path(action.payload.metrics_dashboard_id)));
    yield put(showSnackbar({
      message: 'Metrics dashboard created',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createCustomGraphError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to create graph',
      options: { variant: 'warning' }
    }));
  }
}

export function* updateCustomGraph(action) {
  try {
    const payload = { graph: action.payload };
    const response = yield call(api.metrics.customGraphs.update.bind(api.metrics.customGraphs),
      payload.graph.id, payload);

    yield put(push(ROUTES.admin.analyze.custom.show.path(action.payload.metrics_dashboard_id)));
    yield put(showSnackbar({
      message: 'Graph updated',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateCustomGraphError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to update graph',
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteCustomGraph(action) {
  try {
    yield call(api.metrics.customGraphs.destroy.bind(api.metrics.customGraphs), action.payload);

    // TODO: re render page
    window.location.reload();

    yield put(showSnackbar({
      message: 'Metrics dashboard deleted',
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteCustomGraphError(err));

    // TODO: intl message
    yield put(showSnackbar({
      message: 'Failed to delete graph',
      options: { variant: 'warning' }
    }));
  }
}


export default function* customMetricsSaga() {
  /* Dashboards */
  yield takeLatest(GET_METRICS_DASHBOARDS_BEGIN, getMetricsDashboards);
  yield takeLatest(GET_METRICS_DASHBOARD_BEGIN, getMetricsDashboard);
  yield takeLatest(CREATE_METRICS_DASHBOARD_BEGIN, createMetricsDashboard);
  yield takeLatest(UPDATE_METRICS_DASHBOARD_BEGIN, updateMetricsDashboard);
  yield takeLatest(DELETE_METRICS_DASHBOARD_BEGIN, deleteMetricsDashboard);

  /* Graphs */
  yield takeLatest(GET_CUSTOM_GRAPH_BEGIN, getCustomGraph);
  yield takeLatest(GET_CUSTOM_GRAPH_DATA_BEGIN, getCustomGraphData);
  yield takeLatest(CREATE_CUSTOM_GRAPH_BEGIN, createCustomGraph);
  yield takeLatest(UPDATE_CUSTOM_GRAPH_BEGIN, updateCustomGraph);
  yield takeLatest(DELETE_CUSTOM_GRAPH_BEGIN, deleteCustomGraph);
}
