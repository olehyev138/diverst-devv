import { call, put, takeLatest } from 'redux-saga/effects';
import { LOG_OUT, LOG_OUT_ERROR } from "containers/App/constants";
import api from "api/api";
import { toast } from "react-toastify";
import { loggingOutError } from "containers/App/actions";
import { push } from 'connected-react-router';

import AuthService from "utils/authService";


// TODO: can these go under App/ so that we can use them globally?

export function* logout(action) {
  AuthService.clear();

  // Destroy sesssion and redirect to login
  try {
    yield call(api.sessions.destroy.bind(api.sessions), action.token);
    yield put(push("/login"));
  }
  catch (err) {
    yield put(loggingOutError(err));
    yield put(push("/login"));
  }
}

export function* displayError(action) {
  // TODO: this is repeated, can it be reused?
  toast(action.error.toString(), { hideProgressBar: true, type: "error" });
}

export default function* handleHomePage() {
  yield takeLatest(LOG_OUT, logout);
  yield takeLatest(LOG_OUT_ERROR, displayError);
}
