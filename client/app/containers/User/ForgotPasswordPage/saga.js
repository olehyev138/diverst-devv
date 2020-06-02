import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  REQUEST_PASSWORD_RESET_BEGIN,
  GET_USER_BY_TOKEN_BEGIN,
  SUBMIT_PASSWORD_BEGIN,
} from './constants';

import {
  requestPasswordResetSuccess, requestPasswordResetError,
  getUserByTokenSuccess, getUserByTokenError,
  submitPasswordSuccess, submitPasswordError,
} from './actions';

export function* requestPasswordReset(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(requestPasswordResetSuccess({}));
    yield put(showSnackbar({ message: 'Successfully requested password reset', options: { variant: 'success' } }));
  } catch (err) {
    yield put(requestPasswordResetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to request password reset', options: { variant: 'warning' } }));
  }
}

export function* getUserByToken(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(getUserByTokenSuccess(response.data));
  } catch (err) {
    yield put(getUserByTokenError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to get user by token', options: { variant: 'warning' } }));
  }
}

export function* submitPassword(action) {
  try {
    const response = { data: 'API CALL' };

    yield put(submitPasswordSuccess({}));
    yield put(showSnackbar({ message: 'Successfully submitted password', options: { variant: 'success' } }));
  } catch (err) {
    yield put(submitPasswordError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to submit password', options: { variant: 'warning' } }));
  }
}


export default function* ForgotPasswordSaga() {
  yield takeLatest(REQUEST_PASSWORD_RESET_BEGIN, requestPasswordReset);
  yield takeLatest(GET_USER_BY_TOKEN_BEGIN, getUserByToken);
  yield takeLatest(SUBMIT_PASSWORD_BEGIN, submitPassword);
}
