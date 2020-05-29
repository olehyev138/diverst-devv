import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  GET_USER_BY_TOKEN_BEGIN,
  SUBMIT_PASSWORD_BEGIN,
} from './constants';

import {
  getUserByTokenSuccess, getUserByTokenError,
  submitPasswordSuccess, submitPasswordError,
} from './actions';

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


export default function* ForgotpasswordpageSaga() {
  yield takeLatest(GET_USER_BY_TOKEN_BEGIN, getUserByToken);
  yield takeLatest(SUBMIT_PASSWORD_BEGIN, submitPassword);
}
