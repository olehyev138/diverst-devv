/*
 *
 * LoginPage reducer
 *
 */
import produce from 'immer';

import { LOGIN_BEGIN, LOGIN_ERROR } from 'containers/App/constants';

export const initialState = {};

/* eslint-disable default-case, no-param-reassign */
// const loginPageReducer = (state = initialState, action) =>
function loginPageReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // TODO: what do these do?
    switch (action.type) {
      case LOGIN_BEGIN:
        draft.loggingIn = action.loggingIn;
        break;
      case LOGIN_ERROR:
        draft.error = action.error;
        break;
    }
  });
}

export default loginPageReducer;
