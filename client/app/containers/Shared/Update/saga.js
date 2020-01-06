import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_UPDATE_BEGIN,
  GET_UPDATES_BEGIN,
  CREATE_UPDATE_BEGIN,
  UPDATE_UPDATE_BEGIN,
  DELETE_UPDATE_BEGIN,
} from './constants';

import {
  getUpdateSuccess, getUpdateError,
  getUpdatesSuccess, getUpdatesError,
  createUpdateSuccess, createUpdateError,
  updateUpdateSuccess, updateUpdateError,
  deleteUpdateSuccess, deleteUpdateError,
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
    const response = { data: 'API CALL' };

    yield put(updateUpdateSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update update', options: { variant: 'warning' } }));
  }
}

export function* deleteUpdate(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteUpdateSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete update', options: { variant: 'warning' } }));
  }
}


export default function* UpdateSaga() {
  yield takeLatest(GET_UPDATE_BEGIN, getUpdate);
  yield takeLatest(UPDATE_UPDATE_BEGIN, updateUpdate);
  yield takeLatest(DELETE_UPDATE_BEGIN, deleteUpdate);
}
