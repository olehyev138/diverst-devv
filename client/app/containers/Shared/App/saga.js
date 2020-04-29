import { call, put, takeLatest } from 'redux-saga/effects';
import api from 'api/api';
import { push } from 'connected-react-router';

import {
  LOGIN_BEGIN,
  LOGIN_ERROR,
  LOGOUT_BEGIN,
  LOGOUT_ERROR,
  FIND_ENTERPRISE_BEGIN,
  FIND_ENTERPRISE_ERROR,
  SSO_LOGIN_BEGIN,
  SSO_LINK_BEGIN
}
  from './constants';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  loginSuccess,
  loginError,
  logoutSuccess,
  logoutError,
  findEnterpriseSuccess,
  findEnterpriseError,
  setUserData,
}
  from './actions';

import { showSnackbar } from 'containers/Shared/Notifier/actions';

import AuthService from 'utils/authService';
import { resolveRootManagePath } from 'utils/adminLinkHelpers';

const axios = require('axios');

export function* login(action) {
  try {
    // Create a new session given credentials & dispatch a loggedIn action
    // payload is user credentials
    const response = yield call(api.sessions.create.bind(api.sessions), action.payload);

    // eslint-disable-next-line camelcase
    const { token } = response.data;

    yield put(loginSuccess(token));
    axios.defaults.headers.common['Diverst-UserToken'] = token;

    yield call(AuthService.storeJwt, token);

    yield put(push(ROUTES.user.home.path()));
  } catch (err) {
    yield put(loginError(err));
    yield put(showSnackbar({ message: err.response.data, options: { variant: 'error', autoHideDuration: 2500 } }));
  }
}

// TODO: Make this work
export function* ssoLogin(action) {
  try {
    axios.defaults.headers.common['Diverst-UserToken'] = action.payload.userToken;
    yield put(loginSuccess(action.payload.userToken));

    yield call(AuthService.storeJwt, action.payload.userToken);

    // decode token to get user object
    // const user = yield call(AuthService.getUser, action.payload.userToken);

    // yield put(setUser(user));
    // yield put(setUserPolicyGroup(user.policy_group));
    yield put(push(ROUTES.user.home.path()));
  } catch (err) {
    yield put(loginError(err));
    yield put(showSnackbar({ message: err }));
  }
}

export function* ssoLinkFind(action) {
  try {
    const response = yield call(api.enterprises.getSsoLink.bind(api.enterprises), action.payload.enterpriseId, { relay_state: action.payload.relayState });
    window.location.assign(response.data);
  } catch (err) {
    yield put(loginError(err));
    yield put(showSnackbar({ message: err.response.data }));
  }
}

export function* logout() {
  try {
    // Destroy session and redirect to login
    const response = yield call(api.sessions.logout.bind(api.sessions));

    yield call(AuthService.discardJwt);
    yield put(logoutSuccess());

    if (response.data.logout_link)
      window.location.assign(response.data.logout_link);
    else
      yield put(showSnackbar({ message: 'You have been logged out', options: { variant: 'info', autoHideDuration: 2500 } }));
  } catch (err) {
    yield put(logoutError(err));

    // Even if logout fails clear the local data
    yield call(AuthService.discardJwt);
    yield put(logoutSuccess());

    yield put(showSnackbar({ message: 'You have been logged out', options: { variant: 'info', autoHideDuration: 2500 } }));
  }
}

export function* findEnterprise(action) {
  try {
    // Find enterprise and dispatch setEnterprise action
    const response = yield call(api.enterprises.getAuthEnterprise.bind(api.enterprises), action.payload);
    const { enterprise } = response.data;
    yield put(findEnterpriseSuccess());

    // Set enterprise
    yield put(setUserData({ enterprise }, true));
  } catch (err) {
    yield put(findEnterpriseError(err));
  }
}

export default function* handleLogin() {
  yield takeLatest(LOGIN_BEGIN, login);

  yield takeLatest(SSO_LINK_BEGIN, ssoLinkFind);

  yield takeLatest(SSO_LOGIN_BEGIN, ssoLogin);

  yield takeLatest(LOGOUT_BEGIN, logout);

  yield takeLatest(FIND_ENTERPRISE_BEGIN, findEnterprise);
}
