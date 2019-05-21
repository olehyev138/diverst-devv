import { call, put, takeLatest } from "redux-saga/effects";
import api from 'api/api';
import { toast } from 'react-toastify';
import { push } from 'connected-react-router';

import {HANDLE_LOGIN, LOGIN_ERROR, HANDLE_FIND_ENTERPRISE, FIND_ENTERPRISE_ERROR} from './constants';
import {findEnterpriseError, loginError} from './actions';
import { loggedIn, setUser, setEnterprise } from 'containers/App/actions';

import AuthService from 'utils/authService'
//import { changePrimary, changeSecondary } from "containers/ThemeProvider/actions";

const axios = require("axios");

export function* login(action) {
  try {
    // Create a new session given credentials & dispatch a loggedIn action
    const response = yield call(api.sessions.create.bind(api.sessions), action.payload);
    yield put(loggedIn(response.data.token));

    AuthService.setValue('_diverst.twj', response.data.token);
    axios.defaults.headers.common['Diverst-UserToken'] = response.data.token;

    // TODO: make this more clear, encapsulate in api library?
    const user = JSON.parse(window.atob(response.data.token.split('.')[1]));

    yield put(setUser(user));
    //yield put(push('/home'))
  }
  catch (err) {
    yield put(loginError(err));
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
      //yield put(changePrimary(enterprise.theme.primary_color));
      //yield put(changeSecondary(enterprise.theme.secondary_color));
    }
  }
  catch (err) {
    yield put(findEnterpriseError());
  }
}

export function* displayError(action) {
  console.log('hello?');
  console.log(action);
  toast(action.error.response.data, { hideProgressBar: true, type: 'error' });
}

export default function* handleLogin() {
  yield takeLatest(HANDLE_LOGIN, login);
  yield takeLatest(LOGIN_ERROR, displayError);
  yield takeLatest(HANDLE_FIND_ENTERPRISE, findEnterprise);
  yield takeLatest(FIND_ENTERPRISE_ERROR, displayError);
}
