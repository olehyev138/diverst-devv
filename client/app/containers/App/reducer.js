/*
 * AppReducer
 *
 * The reducer takes care of our data. Using actions, we can change our
 * application state.
 * To add a new action, add it to the switch statement in the reducer function
 *
 * Example:
 * case YOUR_ACTION_CONSTANT:
 *   return state.set('yourStateVariable', true);
 */

import { fromJS } from "immutable";
import { LOGGED_IN, LOG_OUT, LOG_OUT_ERROR, SET_CURRENT_USER, SET_ENTERPRISE } from "./constants";

// The initial state of the App
export const initialState = fromJS({
    loading: false,
    currentUser: null,
    enterprise: null,
    domain: null,
    token: null,
    primary: "#3f51b5",
    secondary: "#f50057"
});

function appReducer(state = initialState, action) {
    switch (action.type) {
        case LOGGED_IN:
            return state.set("token", action.token);
        case LOG_OUT:
            return state.set("token", null);
        case LOG_OUT_ERROR:
            return state.set("error", action.error);
        case SET_CURRENT_USER:
            return state.set("currentUser", action.user);
        case SET_ENTERPRISE:
            return state.set("enterprise", action.enterprise);
        default:
            return state;
    }
}

export default appReducer;
