/**
 * Gets the repositories of the user from Github
 */

import { call, put, takeLatest } from "redux-saga/effects";
import api from "api/api";
import { toast } from "react-toastify";
import { HANDLE_SUBMIT, LOGGING_IN_ERROR, HANDLE_FIND_COMPANY } from "./constants";
import { loggingInError } from "./actions";
import { loggedIn, setCurrentUser, setEnterprise } from "containers/App/actions";
import { changePrimary, changeSecondary } from "containers/ThemeProvider/actions";
import { push } from 'connected-react-router';
const axios = require("axios");

import AuthService from "utils/authService";

/**
 * Github repos request/response handler
 */
export function* login(action) {
    try {
        const response = yield call(api.sessions.create.bind(api.sessions), action.payload);
        yield put(loggedIn(response.data.token));
        AuthService.setValue("_diverst.twj", response.data.token);
        axios.defaults.headers.common['Diverst-UserToken'] = response.data.token;
        const user = JSON.parse(window.atob(response.data.token.split('.')[1]));
        yield put(setCurrentUser(user));
        yield put(push("/home"));
    }
    catch (err) {
        yield put(loggingInError(err));
    }
}

export function* findCompany(action) {
    try {
        const response = yield call(api.users.findCompany.bind(api.users), action.payload);
        const enterprise = response.data.enterprise;
        yield put(setEnterprise(enterprise));
        AuthService.setValue("_diverst.seirpretne", enterprise);
        if(response.data.enterprise.theme){
            yield put(changePrimary(enterprise.theme.primary_color));
            yield put(changeSecondary(enterprise.theme.secondary_color));
        }
    }
    catch (err) {
        console.log(err);
    }
}

export function* display(action) {
    toast(action.error.response.data, { hideProgressBar: true, type: "error" });
}

/**
 * Root saga manages watcher lifecycle
 */
export default function* handleLogin() {
    yield takeLatest(HANDLE_SUBMIT, login);
    yield takeLatest(LOGGING_IN_ERROR, display);
    yield takeLatest(HANDLE_FIND_COMPANY, findCompany);
}
