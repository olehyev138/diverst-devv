import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import messages from './messages';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';

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
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.get_update), options: { variant: 'warning' } }));
  }
}

export function* updateUpdate(action) {
  try {
    const { redirectPath, ...rest } = action.payload;
    const payload = { update: rest };
    const response = yield call(api.updates.update.bind(api.updates), payload.update.id, payload);

    yield put(updateUpdateSuccess({}));
    yield put(push(redirectPath));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.update), options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUpdateError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.update), options: { variant: 'warning' } }));
  }
}

export function* deleteUpdate(action) {
  try {
    const { payload } = action;
    const response = yield call(api.updates.destroy.bind(api.updates), payload);

    yield put(deleteUpdateSuccess({}));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.delete), options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteUpdateError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.delete), options: { variant: 'warning' } }));
  }
}

export function* getUpdates(action, updatableKey) {
  try {
    const { updatableId, ...payload } = action.payload;
    payload[updatableKey] = updatableId;

    const response = yield call(api.updates.all.bind(api.updates), payload);

    yield put(getUpdatesSuccess(response.data.page));
  } catch (err) {
    yield put(getUpdatesError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.updates), options: { variant: 'warning' } }));
  }
}

export function* getUpdatePrototype(action, updatableKey) {
  try {
    const { updatableId, ...payload } = action.payload;
    payload[updatableKey] = updatableId;

    const response = yield call(api.updates.prototype.bind(api.updates), payload);

    yield put(getUpdatePrototypeSuccess(response.data));
  } catch (err) {
    yield put(getUpdatePrototypeError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.prototype), options: { variant: 'warning' } }));
  }
}

export function* createUpdate(action, updatableKey) {
  try {
    const { updatableId, redirectPath, ...rest } = action.payload;

    const payload = { update: rest };
    payload[updatableKey] = updatableId;
    const response = yield call(api.updates.create.bind(api.updates), payload);

    yield put(createUpdateSuccess({}));
    yield put(push(redirectPath));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.success.create), options: { variant: 'success' } }));
  } catch (err) {
    yield put(createUpdateError(err));
    yield put(showSnackbar({ message: intl.formatMessage(messages.snackbars.errors.create), options: { variant: 'warning' } }));
  }
}

export default function* UpdateSaga() {
  yield takeLatest(GET_UPDATE_BEGIN, getUpdate);
  yield takeLatest(UPDATE_UPDATE_BEGIN, updateUpdate);
  yield takeLatest(DELETE_UPDATE_BEGIN, deleteUpdate);
}
