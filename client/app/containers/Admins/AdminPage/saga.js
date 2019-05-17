/**
 * Gets the repositories of the user from Github
 */

import { call, put, takeLatest } from "redux-saga/effects";
import api from "api/api";
import { toast } from "react-toastify";
import { LOG_OUT, LOG_OUT_ERROR } from "containers/App/constants";
import { loggingOutError } from "containers/App/actions";
import { push } from 'connected-react-router';
import AuthService from "utils/authService";

/**
 * Github repos request/response handler
 */
export function* logout(action) {
    AuthService.clear();
    try {
        yield call(api.sessions.destroy.bind(api.sessions), action.token);
        yield put(push("/login"));
    }
    catch (err) {
        yield put(loggingOutError(err));
        yield put(push("/login"));
    }
}

export function* display(action) {
    toast(action.error.toString(), { hideProgressBar: true, type: "error" });
}

/**
 * Root saga manages watcher lifecycle
 */
export default function* handleHomePage() {
    yield takeLatest(LOG_OUT, logout);
    yield takeLatest(LOG_OUT_ERROR, display);
}
