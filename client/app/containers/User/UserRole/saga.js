import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import {
  GET_USER_ROLES_BEGIN, CREATE_USER_ROLE_BEGIN,
  GET_USER_ROLE_BEGIN, UPDATE_USER_ROLE_BEGIN, DELETE_USER_ROLE_BEGIN,
} from 'containers/User/UserRole/constants';

import {
  getUserRolesSuccess, getUserRolesError,
  getUserRoleSuccess, getUserRoleError,
  createUserRoleSuccess, createUserRoleError,
  updateUserRoleSuccess, updateUserRoleError,
  deleteUserRoleError, deleteUserRoleSuccess
} from 'containers/User/UserRole/actions';

import { ROUTES } from 'containers/Shared/Routes/constants';

export function* getUserRoles(action) {
  try {
    const response = yield call(api.userRoles.all.bind(api.userRoles), action.payload);
    yield put(getUserRolesSuccess(response.data.page));
  } catch (err) {
    yield put(getUserRolesError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to load user roles', options: { variant: 'warning' } }));
  }
}

export function* getUserRole(action) {
  try {
    const response = yield call(api.userRoles.get.bind(api.userRoles), action.payload.id);
    yield put(getUserRoleSuccess(response.data));
  } catch (err) {
    // TODO: intl message
    yield put(getUserRoleError(err));
    yield put(showSnackbar({ message: 'Failed to get user', options: { variant: 'warning' } }));
  }
}

export function* createUserRole(action) {
  try {
    const payload = { user: action.payload };

    const response = yield call(api.users.create.bind(api.users), payload);

    yield put(createUserRoleSuccess());
    yield put(push(ROUTES.admin.system.users.index.path()));
    yield put(showSnackbar({ message: 'UserRole created', options: { variant: 'success' } }));
  } catch (err) {
    yield put(createUserRoleError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to create user', options: { variant: 'warning' } }));
  }
}

export function* updateUserRole(action) {
  try {
    const payload = { user: action.payload };
    const response = yield call(api.users.update.bind(api.users), payload.user.id, payload);

    yield put(updateUserRoleSuccess());
    yield put(push(payload.user.redirectPath || ROUTES.admin.system.users.index.path()));
    yield put(showSnackbar({ message: 'UserRole updated', options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUserRoleError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export function* deleteUserRole(action) {
  try {
    yield call(api.users.destroy.bind(api.users), action.payload);

    yield put(deleteUserRoleSuccess());
    yield put(push(ROUTES.admin.system.users.index.path()));
    yield put(showSnackbar({ message: 'UserRole deleted', options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteUserRoleError(err));

    // TODO: intl message
    yield put(showSnackbar({ message: 'Failed to update user', options: { variant: 'warning' } }));
  }
}

export default function* usersSaga() {
  yield takeLatest(GET_USER_ROLES_BEGIN, getUserRoles);
  yield takeLatest(GET_USER_ROLE_BEGIN, getUserRole);
  yield takeLatest(CREATE_USER_ROLE_BEGIN, createUserRole);
  yield takeLatest(UPDATE_USER_ROLE_BEGIN, updateUserRole);
  yield takeLatest(DELETE_USER_ROLE_BEGIN, deleteUserRole);
}
