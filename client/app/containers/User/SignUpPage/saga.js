import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USER_BY_TOKEN_BEGIN,
  SUBMIT_PASSWORD_BEGIN,
} from './constants';

import {
  getUserByTokenSuccess, getUserByTokenError,
  submitPasswordSuccess, submitPasswordError
} from './actions';
import { loginBegin, logoutBegin } from 'containers/Shared/App/actions';
import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getUserByToken(action) {
  try {
    const response = yield call(api.users.getInvitedUser.bind(api.users), action.payload);

    yield put(getUserByTokenSuccess(response.data));
  } catch (err) {
    yield put(getUserByTokenError());

    yield put(showSnackbar({ message: err.response.data, options: { variant: 'warning' } }));
  }
}

export function* submitPassword(action) {
  try {
    const { token, ...rest } = action.payload;
    const payload = { token, user: rest };

    const response = yield call(api.users.signUpUser.bind(api.users), payload);
    yield put(submitPasswordSuccess({ data: response.data, contentType: response.headers['content-type'] }));

    yield put(loginBegin({
      email: rest.email,
      password: rest.password,
    }));
  } catch (err) {
    yield put(submitPasswordError(err.response.data));

    // TODO: intl message

    yield put(showSnackbar({ message: err.response.data, options: { variant: 'warning' } }));
    if (err.response.status === 400)
      yield put(push(ROUTES.session.login.path()));
  }
}

export default function* usersSaga() {
  yield takeLatest(GET_USER_BY_TOKEN_BEGIN, getUserByToken);
  yield takeLatest(SUBMIT_PASSWORD_BEGIN, submitPassword);
}
