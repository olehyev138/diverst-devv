import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_MENTORSHIP_USERS_BEGIN,
  GET_MENTORSHIP_USER_BEGIN,
  UPDATE_MENTORSHIP_USER_BEGIN,
} from 'containers/Mentorship/constants';

import {
  getUsersSuccess, getUsersError,
  getUserSuccess, getUserError,
  updateUserSuccess, updateUserError,
} from 'containers/Mentorship/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

function addSerializer(action) {
  action.payload.serializer = 'mentorship';
}

export function* getUsers(action) {
  try {
    addSerializer(action);
    const response = yield call(api.users.all.bind(api.users), action.payload);
    yield put(getUsersSuccess(response.data.page));
  } catch (err) {
    yield put(getUsersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load users', options: { variant: 'warning' } }));
  }
}

export function* getUser(action) {
  try {
    addSerializer(action);
    const response = yield call(api.users.get.bind(api.users), action.payload.id, { serializer: action.payload.serializer });
    yield put(getUserSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getUserError(err));
    yield put(showSnackbar({ message: 'Failed to get user', options: { variant: 'warning' } }));
  }
}

export function* updateUser(action) {
  try {
    addSerializer(action);
    const payload = { user: action.payload };
    const response = yield call(api.users.update.bind(api.users), payload.user.id, payload);

    yield put(push(ROUTES.admin.system.users.index.path()));
    yield put(showSnackbar({ message: 'User updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}


export default function* usersSaga() {
  yield takeLatest(GET_MENTORSHIP_USERS_BEGIN, getUsers);
  yield takeLatest(GET_MENTORSHIP_USER_BEGIN, getUser);
  yield takeLatest(UPDATE_MENTORSHIP_USER_BEGIN, updateUser);
}
