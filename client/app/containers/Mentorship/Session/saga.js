import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_SESSION_BEGIN,
  GET_SESSIONS_BEGIN,
  CREATE_SESSION_BEGIN,
  UPDATE_SESSION_BEGIN,
  DELETE_SESSION_BEGIN,
} from './constants';

import {
  getSessionSuccess, getSessionError,
  getSessionsSuccess, getSessionsError,
  createSessionSuccess, createSessionError,
  updateSessionSuccess, updateSessionError,
  deleteSessionSuccess, deleteSessionError,
} from './actions';

export function* getSession(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getSessionSuccess(response.data));
  } catch (err) {
    yield put(getSessionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get session', options: { variant: 'warning' } }));
  }
}

export function* getSessions(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getSessionsSuccess(response.data.page));
  } catch (err) {
    yield put(getSessionsError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get sessions', options: { variant: 'warning' } }));
  }
}

export function* createSession(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(createSessionSuccess({}));
    yield put(showSnackbar({ message: 'Successfully created session', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createSessionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create session', options: { variant: 'warning' } }));
  }
}

export function* updateSession(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(updateSessionSuccess({}));
    yield put(showSnackbar({ message: 'Successfully updated session', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateSessionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update session', options: { variant: 'warning' } }));
  }
}

export function* deleteSession(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(deleteSessionSuccess({}));
    yield put(showSnackbar({ message: 'Successfully deleted session', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteSessionError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to delete session', options: { variant: 'warning' } }));
  }
}


export default function* SessionSaga() {
  yield takeLatest(GET_SESSION_BEGIN, getSession);
  yield takeLatest(GET_SESSIONS_BEGIN, getSessions);
  yield takeLatest(CREATE_SESSION_BEGIN, createSession);
  yield takeLatest(UPDATE_SESSION_BEGIN, updateSession);
  yield takeLatest(DELETE_SESSION_BEGIN, deleteSession);
}
