import { call, put, takeLatest, takeEvery } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import messages from './messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

import {
  GET_METRICS_DASHBOARDS_BEGIN, GET_METRICS_DASHBOARD_BEGIN,
  CREATE_METRICS_DASHBOARD_BEGIN, UPDATE_METRICS_DASHBOARD_BEGIN,
  DELETE_METRICS_DASHBOARD_BEGIN,
} from 'containers/Analyze/Dashboards/MetricsDashboard/constants';

import {
  getMetricsDashboardBegin,
  getMetricsDashboardsSuccess, getMetricsDashboardsError,
  getMetricsDashboardSuccess, getMetricsDashboardError,
  createMetricsDashboardSuccess, createMetricsDashboardError,
  updateMetricsDashboardSuccess, updateMetricsDashboardError,
  deleteMetricsDashboardError, deleteMetricsDashboardSuccess,
} from 'containers/Analyze/Dashboards/MetricsDashboard/actions';

import {
  GET_CUSTOM_GRAPH_BEGIN, CREATE_CUSTOM_GRAPH_BEGIN, UPDATE_CUSTOM_GRAPH_BEGIN,
  GET_CUSTOM_GRAPH_DATA_BEGIN, DELETE_CUSTOM_GRAPH_BEGIN
} from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/constants';

import {
  getCustomGraphSuccess, getCustomGraphDataSuccess,
  createCustomGraphSuccess, createCustomGraphError,
  updateCustomGraphSuccess, updateCustomGraphError,
  deleteCustomGraphError, deleteCustomGraphSuccess
} from 'containers/Analyze/Dashboards/MetricsDashboard/CustomGraph/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';


/* Metrics Dashboard */

export function* getMetricsDashboards(action) {
  try {
    const response = yield call(api.metrics.metricsDashboards.all.bind(api.metrics.metricsDashboards), action.payload);

    yield (put(getMetricsDashboardsSuccess(response.data.page)));
  } catch (err) {
    yield put(getMetricsDashboardsError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.dashboards,
      options: { variant: 'warning' }
    }));
  }
}

export function* getMetricsDashboard(action) {
  try {
    const response = yield call(api.metrics.metricsDashboards.get.bind(api.metrics.metricsDashboards), action.payload.id);
    yield put(getMetricsDashboardSuccess(response.data));
  } catch (err) {
    yield put(getMetricsDashboardError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.dashboard,
      options: { variant: 'warning' }
    }));
  }
}

export function* createMetricsDashboard(action) {
  try {
    const payload = { metrics_dashboard: action.payload };
    const response = yield call(api.metrics.metricsDashboards.create.bind(api.metrics.metricsDashboards), payload);

    yield put(createMetricsDashboardSuccess());
    yield put(push(ROUTES.admin.analyze.custom.index.path()));
    yield put(showSnackbar({
      message: messages.snackbars.success.create_dashboard,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createMetricsDashboardError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.create_dashboard,
      options: { variant: 'warning' }
    }));
  }
}

export function* updateMetricsDashboard(action) {
  try {
    const payload = { metrics_dashboard: action.payload };
    const response = yield call(api.metrics.metricsDashboards.update.bind(api.metrics.metricsDashboards),
      payload.metrics_dashboard.id, payload);

    yield put(updateMetricsDashboardSuccess());
    yield put(push(ROUTES.admin.analyze.custom.index.path()));
    yield put(showSnackbar({
      message: messages.snackbars.success.update_dashboard,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateMetricsDashboardError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.update_dashboard,
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteMetricsDashboard(action) {
  try {
    yield call(api.metrics.metricsDashboards.destroy.bind(api.metrics.metricsDashboards), action.payload);

    yield put(deleteMetricsDashboardSuccess());
    yield put(push(ROUTES.admin.analyze.custom.index.path()));
    yield put(showSnackbar({
      message: messages.snackbars.success.delete_dashboard,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteMetricsDashboardError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.delete_dashboard,
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
    yield put(getMetricsDashboardError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.graph,
      options: { variant: 'warning' }
    }));
  }
}

export function* getCustomGraphData(action) {
  try {
    const response = yield call(api.metrics.customGraphs.data.bind(api.metrics.customGraphs), { graph: action.payload });
    yield put(getCustomGraphDataSuccess({ id: action.payload.id, data: response.data }));
  } catch (err) {
    yield put(getMetricsDashboardError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.graph_data,
      options: { variant: 'warning' }
    }));
  }
}

export function* createCustomGraph(action) {
  try {
    const payload = { graph: action.payload };
    const response = yield call(api.metrics.customGraphs.create.bind(api.metrics.customGraphs), payload);

    yield put(createCustomGraphSuccess());
    yield put(push(ROUTES.admin.analyze.custom.show.path(action.payload.metrics_dashboard_id)));
    yield put(showSnackbar({
      message: messages.snackbars.success.create_graph,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(createCustomGraphError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.create_graph,
      options: { variant: 'warning' }
    }));
  }
}

export function* updateCustomGraph(action) {
  try {
    const payload = { graph: action.payload };
    const response = yield call(api.metrics.customGraphs.update.bind(api.metrics.customGraphs),
      payload.graph.id, payload);

    yield put(updateCustomGraphSuccess());
    yield put(push(ROUTES.admin.analyze.custom.show.path(action.payload.metrics_dashboard_id)));
    yield put(showSnackbar({
      message: messages.snackbars.success.update_graph,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(updateCustomGraphError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.update_graph,
      options: { variant: 'warning' }
    }));
  }
}

export function* deleteCustomGraph(action) {
  try {
    yield call(api.metrics.customGraphs.destroy.bind(api.metrics.customGraphs), action.payload.graphId);

    yield put(deleteCustomGraphSuccess(action.payload));
    yield put(getMetricsDashboardBegin({ id: action.payload.dashboardId }));
    yield put(showSnackbar({
      message: messages.snackbars.success.delete_graph,
      options: { variant: 'success' }
    }));
  } catch (err) {
    yield put(deleteCustomGraphError(err));
    yield put(showSnackbar({
      message: messages.snackbars.errors.delete_graph,
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
  yield takeEvery(GET_CUSTOM_GRAPH_DATA_BEGIN, getCustomGraphData);
  yield takeLatest(CREATE_CUSTOM_GRAPH_BEGIN, createCustomGraph);
  yield takeLatest(UPDATE_CUSTOM_GRAPH_BEGIN, updateCustomGraph);
  yield takeLatest(DELETE_CUSTOM_GRAPH_BEGIN, deleteCustomGraph);
}
