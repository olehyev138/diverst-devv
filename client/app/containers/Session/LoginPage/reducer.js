/*
 *
 * LoginPage reducer
 *
 */
import produce from 'immer';
import dig from 'object-dig';

import {
  FIND_ENTERPRISE_BEGIN, FIND_ENTERPRISE_SUCCESS, FIND_ENTERPRISE_ERROR, LOGIN_BEGIN, LOGIN_SUCCESS, LOGIN_ERROR
} from 'containers/Shared/App/constants';

export const initialState = {
  globalError: null,
  formErrors: {
    email: null,
    password: null,
  },
};

function loginPageReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // TODO: what do these do?
    switch (action.type) {
      case FIND_ENTERPRISE_BEGIN:
        draft.formErrors = initialState.formErrors;
        break;
      case FIND_ENTERPRISE_ERROR:
        draft.formErrors.email = dig(action, 'error', 'response', 'data');
        break;
      case LOGIN_BEGIN:
        draft.formErrors = initialState.formErrors;
        draft.loggingIn = action.loggingIn;
        break;
      case LOGIN_ERROR:
        draft.formErrors.password = dig(action, 'error', 'response', 'data');
        break;
    }
  });
}

export default loginPageReducer;
