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
} from 'containers/Shared/Update/constants';

import {
  getUpdatesSuccess, getUpdatesError,
  createUpdateSuccess, createUpdateError,
} from 'containers/Shared/Update/actions';

import {
  getUpdate, updateUpdate, deleteUpdate
} from 'containers/Shared/Update/saga';

export function* getUpdates(action) {
  try {
    const { groupId, ...payload } = action.payload;
    const response = yield call(api.groups.updates.bind(api.groups), groupId, payload);

    yield put(getUpdatesSuccess(response.data.page));
  } catch (err) {
    yield put(getUpdatesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get updates', options: { variant: 'warning' } }));
  }
}

export function* createUpdate(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createUpdateSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created update', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createUpdateError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create update', options: { variant: 'warning' } }));
  }
}

export default function* KpiSaga() {
  yield takeLatest(GET_UPDATE_BEGIN, getUpdate);
  yield takeLatest(GET_UPDATES_BEGIN, getUpdates);
  yield takeLatest(CREATE_UPDATE_BEGIN, createUpdate);
  yield takeLatest(UPDATE_UPDATE_BEGIN, updateUpdate);
  yield takeLatest(DELETE_UPDATE_BEGIN, deleteUpdate);
}
