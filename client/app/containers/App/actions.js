/*
 * App Actions
 *
 * Actions change things in your application
 * Since this boilerplate uses a uni-directional data flow, specifically redux,
 * we have these actions which are the only way your application interacts with
 * your application state. This guarantees that your state is up to date and nobody
 * messes it up weirdly somewhere.
 *
 * To add a new Action:
 * 1) Import your constant
 * 2) Add a function like this:
 *    export function yourAction(var) {
 *        return { type: YOUR_ACTION_CONSTANT, var: var }
 *    }
 */

import { LOGGED_IN, LOG_OUT, LOG_OUT_ERROR, SET_CURRENT_USER, SET_ENTERPRISE } from "./constants";

export function loggedIn(token) {
    return {
        type: LOGGED_IN,
        token: token,
    };
}

export function setCurrentUser(user) {
    return {
        type: SET_CURRENT_USER,
        user: user,
    };
}

export function setEnterprise(enterprise) {
    return {
        type: SET_ENTERPRISE,
        enterprise: enterprise,
    };
}

export function handleLogOut(user) {
    return {
        type: LOG_OUT,
        token: user.user_token
    };
}

export function loggingOutError(error) {
    return {
        type: LOG_OUT_ERROR,
        error: error,
    };
}
