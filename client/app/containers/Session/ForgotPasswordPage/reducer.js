/*
 *
 * ForgotPasswordPage reducer
 *
 */
import produce from 'immer';

import { LOGIN_BEGIN, LOGIN_SUCCESS, LOGIN_ERROR } from 'containers/Shared/App/constants';

export const initialState = {
  isLoggingIn: false,
  loginSuccess: null,
};

function ForgotPasswordPageReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case LOGIN_BEGIN:
        draft.isLoggingIn = true;
        draft.loginSuccess = null;
        break;
      case LOGIN_SUCCESS:
        draft.isLoggingIn = false;
        draft.loginSuccess = true;
        break;
      case LOGIN_ERROR:
        draft.isLoggingIn = false;
        draft.loginSuccess = false;
        break;
    }
  });
}

export default ForgotPasswordPageReducer;
