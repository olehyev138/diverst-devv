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
    // const response = yield call(api.user.getDownloadData.bind(api.user), action.payload);

    // yield put(submitPasswordSuccess({ data: response.data, contentType: response.headers['content-type'] }));
  } catch (err) {
    // yield put(submitPasswordError(err));

    // TODO: intl message
    // yield put(showSnackbar({ message: 'Failed to retrieve file data', options: { variant: 'warning' } }));
  }
}

export default function* usersSaga() {
  yield takeLatest(GET_USER_BY_TOKEN_BEGIN, getUserByToken);
  yield takeLatest(SUBMIT_PASSWORD_BEGIN, submitPassword);
}
