/*
 *
 * LoginPage reducer
 *
 */
import produce from 'immer';

import { SET_ENTERPRISE, FIND_ENTERPRISE_ERROR, LOGIN_BEGIN, LOGIN_ERROR } from 'containers/App/constants';

export const initialState = {
  email: {
    error: null,
  },
  password: {
    error: null,
  }
};

/* eslint-disable default-case, no-param-reassign */
//const loginPageReducer = (state = initialState, action) =>
function loginPageReducer(state = initialState, action) {
  return produce(state, draft => {
    // TODO: what do these do?
    switch (action.type) {
      case SET_ENTERPRISE:
        draft.email.error = null;
        break;
      case FIND_ENTERPRISE_ERROR:
        draft.email.error = action.error.response.data;
        break;
      case LOGIN_BEGIN:
        draft.loggingIn = action.loggingIn;
        break;
      case LOGIN_ERROR:
        draft.password.error = action.error.response.data;
        break;
    }
  });
}

export default loginPageReducer;
