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
    const response = yield call(api.users.requestPasswordReset.bind(api.users), action.payload);

    yield put(requestPasswordResetSuccess({}));
    yield put(showSnackbar({ message: 'Password Reset Email Sent', options: { variant: 'success' } }));
  } catch (err) {
    yield put(requestPasswordResetError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: err.response.data, options: { variant: 'warning' } }));
  }
}

export function* getUserByToken(action) {
  try {
    const response = yield call(api.users.getPasswordToken.bind(api.users), action.payload);

    yield put(getUserByTokenSuccess(response.data));
  } catch (err) {
    yield put(getUserByTokenError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: err.response.data, options: { variant: 'warning' } }));
    yield put(push(ROUTES.session.login.path()));
  }
}

export function* submitPassword(action) {
  try {
    const { token, ...rest } = action.payload;
    const payload = { token, user: rest };

    const response = yield call(api.users.passwordReset.bind(api.users), payload);

    yield put(submitPasswordSuccess({}));
    yield put(showSnackbar({ message: 'Successfully changed password', options: { variant: 'success' } }));
    yield put(push(ROUTES.session.login.path()));
  } catch (err) {
    yield put(submitPasswordError(err));
    // TODO: intl message
    yield put(showSnackbar({ message: err.response.data, options: { variant: 'warning' } }));
    if (err.response.status === 400)
      yield put(push(ROUTES.session.login.path()));
  }
}


export default function* ForgotPasswordSaga() {
  yield takeLatest(REQUEST_PASSWORD_RESET_BEGIN, requestPasswordReset);
  yield takeLatest(GET_USER_BY_TOKEN_BEGIN, getUserByToken);
  yield takeLatest(SUBMIT_PASSWORD_BEGIN, submitPassword);
}
