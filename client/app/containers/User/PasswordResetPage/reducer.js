/*
 *
 * Forgotpasswordpage reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_USER_BY_TOKEN_BEGIN,
  GET_USER_BY_TOKEN_SUCCESS,
  GET_USER_BY_TOKEN_ERROR,
  SUBMIT_PASSWORD_BEGIN,
  SUBMIT_PASSWORD_SUCCESS,
  SUBMIT_PASSWORD_ERROR,
  SIGN_UP_UNMOUNT,
} from './constants';

export const initialState = {
  token: null,
  isLoading: true,
  isCommitting: false,
  user: null,
  errors: null,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function forgotPasswordReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_USER_BY_TOKEN_BEGIN:
        draft.isLoading = true;
        break;

      case GET_USER_BY_TOKEN_SUCCESS:
        draft.isLoading = false;
        draft.user = action.payload.user;
        draft.token = action.payload.token;
        break;

      case GET_USER_BY_TOKEN_ERROR:
        draft.isLoading = false;
        break;

      case SUBMIT_PASSWORD_BEGIN:
        draft.isCommitting = true;
        break;
      case SUBMIT_PASSWORD_SUCCESS:
      case SUBMIT_PASSWORD_ERROR:
        draft.isCommitting = false;
        break;

      case SIGN_UP_UNMOUNT:
        return initialState;
    }
  });
}
export default forgotPasswordReducer;
