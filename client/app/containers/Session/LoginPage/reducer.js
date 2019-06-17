/*
 *
 * LoginPage reducer
 *
 */
import produce from 'immer/dist/immer';

import {
  SET_ENTERPRISE, FIND_ENTERPRISE_ERROR, LOGIN_BEGIN, LOGIN_ERROR
} from 'containers/Shared/App/constants';

export const initialState = {
  email: {
    error: null,
  },
  password: {
    error: null,
  },
};

function loginPageReducer(state = initialState, action) {
  return produce(state, (draft) => {
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
