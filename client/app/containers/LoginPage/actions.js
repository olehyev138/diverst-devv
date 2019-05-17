/*
 * Home Actions
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

import { HANDLE_SUBMIT, LOGGING_IN_ERROR, HANDLE_FIND_COMPANY } from "./constants";


/**
 * Changes the input field of the form
 *
 * @param  {name} name The new text of the input field
 *
 * @return {object}    An action object with a type of HANDLE_CHANGE
 */
export function handleSubmit(payload) {
    return {
        type: HANDLE_SUBMIT,
        loggingIn: true,
		payload: payload,
    };
}

export function handleFindCompany(payload){
    return {
        type: HANDLE_FIND_COMPANY,
        payload: payload
    };
}

export function loggingInError(error) {
    return {
        type: LOGGING_IN_ERROR,
		error: error,
    };
}
