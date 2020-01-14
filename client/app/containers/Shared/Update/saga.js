import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_UPDATE_BEGIN,
  UPDATE_UPDATE_BEGIN,
  DELETE_UPDATE_BEGIN
} from './constants';

import {
  getUpdateSuccess, getUpdateError,
  updateUpdateSuccess, updateUpdateError,
  deleteUpdateSuccess, deleteUpdateError,
  getUpdatesSuccess, getUpdatesError,
  getUpdatePrototypeSuccess, getUpdatePrototypeError,
  createUpdateSuccess, createUpdateError,
} from './actions';

export function* getUpdate(action) {
  try {
    const response = yield call(api.updates.get.bind(api.updates), action.payload);

    yield put(getUpdateSuccess(response.data));
  } catch (err) {
    yield put(getUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get update', options: { variant: 'warning' } }));
  }
}

export function* updateUpdate(action) {
  try {
    const { redirectPath, ...rest } = action.payload;
    const payload = { update: rest };
    const response = yield call(api.updates.update.bind(api.updates), payload.update.id, payload);

    yield put(updateUpdateSuccess({}));
    yield put(push(redirectPath));
    yield put(showSnackbar({ message: 'Successfully updated update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update update', options: { variant: 'warning' } }));
  }
}

export function* deleteUpdate(action) {
  try {
    const { payload } = action;
    const response = yield call(api.updates.destroy.bind(api.updates), payload);

    yield put(deleteUpdateSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete update', options: { variant: 'warning' } }));
  }
}

export function* getUpdates(action, updatableApi) {
  try {
    const { updatableId, ...payload } = action.payload;
    const response = yield call(updatableApi.updates.bind(updatableApi), updatableId, payload);

    yield put(getUpdatesSuccess(response.data.page));
  } catch (err) {
    yield put(getUpdatesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get updates', options: { variant: 'warning' } }));
  }
}

export function* getMetrics(action, updatableApi) {
  try {
    const { updatableId, ...payload } = action.payload;
    const response = yield call(updatableApi.metrics.bind(updatableApi), updatableId, payload);

    yield put(getMetricsSuccess(response.data));
  } catch (err) {
    yield put(getMetricsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get metrics', options: { variant: 'warning' } }));
  }
}


export function* getUpdatePrototype(action, updatableApi) {
  try {
    const { updatableId, ...payload } = action.payload;
    const response = yield call(updatableApi.updatePrototype.bind(updatableApi), updatableId, payload);

    yield put(getUpdatePrototypeSuccess(response.data));
  } catch (err) {
    yield put(getUpdatePrototypeError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get update', options: { variant: 'warning' } }));
  }
}

export function* createUpdate(action, updatableApi) {
  try {
    const { updatableId, redirectPath, ...rest } = action.payload;
    const payload = { update: rest };
    const response = yield call(updatableApi.createUpdates.bind(updatableApi), updatableId, payload);

    yield put(createUpdateSuccess({}));
    yield put(push(redirectPath));
    yield put(showSnackbar({ message: 'Successfully created update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create update', options: { variant: 'warning' } }));
  }
}

export default function* UpdateSaga() {
  yield takeLatest(GET_UPDATE_BEGIN, getUpdate);
  yield takeLatest(UPDATE_UPDATE_BEGIN, updateUpdate);
  yield takeLatest(DELETE_UPDATE_BEGIN, deleteUpdate);
}
