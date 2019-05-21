/*
 *
 * LoginPage reducer
 *
 */
import produce from 'immer';

import { HANDLE_LOGIN, LOGIN_ERROR } from './constants';

export const initialState = {};

/* eslint-disable default-case, no-param-reassign */
//const loginPageReducer = (state = initialState, action) =>
function loginPageReducer(state = initialState, action) {
  return produce(state, draft => {
    // TODO: what do these do?
    switch (action.type) {
      case HANDLE_LOGIN:
        draft['loggingIn'] = action.loggingIn;
        break;
      case LOGIN_ERROR:
        draft['error'] = action.error;
        break;
    }
  });
}

export default loginPageReducer;
