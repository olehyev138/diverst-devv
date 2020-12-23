import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { intl } from 'containers/Shared/LanguageProvider/GlobalLanguageProvider';
import messages from './messages';

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
    yield put(showSnackbar({ message: messages.snackbars.errors.roles, options: { variant: 'warning' } }));
  }
}

export function* getUserRole(action) {
  try {
    const response = yield call(api.userRoles.get.bind(api.userRoles), action.payload.id);
    yield put(getUserRoleSuccess(response.data));
  } catch (err) {
    yield put(getUserRoleError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.role, options: { variant: 'warning' } }));
  }
}

export function* createUserRole(action) {
  try {
    const payload = { user_role: action.payload };

    const response = yield call(api.userRoles.create.bind(api.userRoles), payload);

    yield put(createUserRoleSuccess());
    yield put(push(ROUTES.admin.system.users.roles.index.path()));
    yield put(showSnackbar({ message: messages.snackbars.success.create, options: { variant: 'success' } }));
  } catch (err) {
    yield put(createUserRoleError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.create, options: { variant: 'warning' } }));
  }
}

export function* updateUserRole(action) {
  try {
    const payload = { user_role: action.payload };
    const response = yield call(api.userRoles.update.bind(api.userRoles), payload.user_role.id, payload);

    yield put(updateUserRoleSuccess());
    yield put(push(ROUTES.admin.system.users.roles.index.path()));
    yield put(showSnackbar({ message: messages.snackbars.success.update, options: { variant: 'success' } }));
  } catch (err) {
    yield put(updateUserRoleError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.update, options: { variant: 'warning' } }));
  }
}

export function* deleteUserRole(action) {
  try {
    yield call(api.userRoles.destroy.bind(api.userRoles), action.payload);

    yield put(deleteUserRoleSuccess());
    yield put(push(ROUTES.admin.system.users.roles.index.path()));
    yield put(showSnackbar({ message: messages.snackbars.success.delete, options: { variant: 'success' } }));
  } catch (err) {
    yield put(deleteUserRoleError(err));
    yield put(showSnackbar({ message: messages.snackbars.errors.delete, options: { variant: 'warning' } }));
  }
}

export default function* usersSaga() {
  yield takeLatest(GET_USER_ROLES_BEGIN, getUserRoles);
  yield takeLatest(GET_USER_ROLE_BEGIN, getUserRole);
  yield takeLatest(CREATE_USER_ROLE_BEGIN, createUserRole);
  yield takeLatest(UPDATE_USER_ROLE_BEGIN, updateUserRole);
  yield takeLatest(DELETE_USER_ROLE_BEGIN, deleteUserRole);
}
