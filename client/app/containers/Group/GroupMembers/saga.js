import { call, put, takeLatest } from 'redux-saga/dist/redux-saga-effects-npm-proxy.esm';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USERS_BEGIN, CREATE_USER_BEGIN,
  UPDATE_USER_BEGIN, DELETE_USER_BEGIN
} from 'containers/Group/GroupMembers/constants';

import {
  getUsersSuccess, getUsersError,
  createUserSuccess, createUserError,
  updateUserSuccess, updateUserError,
  deleteUserError
} from 'containers/Group/GroupMembers/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getUsers(action) {
  try {
    const response = yield call(api.userGroups.all.bind(api.userGroups), action.payload);

    yield put(getUsersSuccess(response.data.page));
  } catch (err) {
    yield put(getUsersError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load users', options: { variant: 'warning' } }));
  }
}

export function* createUser(action) {
  try {
    const payload = { user: action.payload };

    // TODO: use bind here or no?
    const response = yield call(api.users.create.bind(api.users), payload);

    yield put(push(ROUTES.admin.manage.users.index.path()));
    yield put(showSnackbar({ message: 'User created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create user', options: { variant: 'warning' } }));
  }
}

export function* addMembers(action) {
  try {
    const payload = { group: action.payload.attributes };
    const response = yield call(api.groups.update.bind(api.groups), action.payload.groupId, payload);

    // yield put(push(ROUTES.admin.manage.users.index.path()));
    yield put(showSnackbar({ message: 'User updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export function* deleteUser(action) {
  try {
    yield call(api.users.destroy.bind(api.users), action.payload);

    yield put(push(ROUTES.admin.manage.users.index.path()));
    yield put(showSnackbar({ message: 'User deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteUserError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export default function* membersSaga() {
  yield takeLatest(GET_USERS_BEGIN, getUsers);

  yield takeLatest(CREATE_USER_BEGIN, addMembers);
  // yield takeLatest(UPDATE_USER_BEGIN, updateUser);

  yield takeLatest(DELETE_USER_BEGIN, deleteUser);
}
