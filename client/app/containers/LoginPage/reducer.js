/*
 * HomeReducer
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

import { HANDLE_SUBMIT, LOGGING_IN_ERROR } from "./constants";

// The initial state of the App
const initialState = fromJS({
    loggingIn: false,
    error: null
});

function loginReducer(state = initialState, action) {
    switch (action.type) {
        case HANDLE_SUBMIT:
            return state.set("loggingIn", action.loggingIn);
        case LOGGING_IN_ERROR:
            return state.set("error", action.error);
        default:
            return state;
    }
}

export default loginReducer;
