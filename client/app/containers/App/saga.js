import { call, put, takeLatest } from "redux-saga/dist/redux-saga-effects-npm-proxy.esm";
import api from 'api/api';
import { toast } from 'react-toastify';
import { push } from 'connected-react-router';

import {
  LOGIN_BEGIN, LOGIN_ERROR,
  LOGOUT_BEGIN, LOGOUT_ERROR,
  FIND_ENTERPRISE_BEGIN, FIND_ENTERPRISE_ERROR
} from './constants';

import {
  loginSuccess, loginError,
  logoutSuccess, logoutError,
  setEnterprise, findEnterpriseError, setUser
} from './actions';

import AuthService from 'utils/authService'
import { changePrimary, changeSecondary } from 'containers/ThemeProvider/actions';

const axios = require('axios');

export function* login(action) {
  try {
    // Create a new session given credentials & dispatch a loggedIn action
    // payload is user credentials
    const response = yield call(api.sessions.create.bind(api.sessions), action.payload);
    yield put(loginSuccess(response.data.token));

    AuthService.setValue('_diverst.twj', response.data.token);
    axios.defaults.headers.common['Diverst-UserToken'] = response.data.token;

    // decode token to get user object
    const user = JSON.parse(window.atob(response.data.token.split('.')[1]));

    yield put(setUser(user));

    // TODO: find better way to do this
    //       - we need to reload to render the parent layout component
    yield put(push('/home'));
  }
  catch (err) {
    yield put(loginError(err));
  }
}

export function* logout(action) {
  AuthService.clear();

  try {
    // Destroy session and redirect to login
    yield call(api.sessions.destroy.bind(api.sessions), action.token);
    yield put(logoutSuccess());

    yield put(push("/login"));
  }
  catch (err) {
    yield put(logoutError(err));
    yield put(push("/login"));
  }
}

export function* findEnterprise(action) {
  try {
    // Find enterprise and dispatch setEnterprise action
    const response = yield call(api.users.findCompany.bind(api.users), action.payload);
    const enterprise = response.data.enterprise;

    yield put(setEnterprise(enterprise));

    AuthService.setValue('_diverst.seirpretne', enterprise);

    // If enterprise has a theme, dispatch theme provider actions
    if(response.data.enterprise.theme){
      yield put(changePrimary(enterprise.theme.primary_color));
      yield put(changeSecondary(enterprise.theme.secondary_color));
    }
  }
  catch (err) {
    yield put(findEnterpriseError());
  }
}

export function* displayError(action) {
  toast(action.error.response.data, { hideProgressBar: true, type: 'error' });
}

export default function* handleLogin() {
  yield takeLatest(LOGIN_BEGIN, login);
  yield takeLatest(LOGIN_ERROR, displayError);

  yield takeLatest(LOGOUT_BEGIN, logout);
  yield takeLatest(LOGOUT_ERROR, displayError);

  yield takeLatest(FIND_ENTERPRISE_BEGIN, findEnterprise);
  yield takeLatest(FIND_ENTERPRISE_ERROR, displayError);
}
