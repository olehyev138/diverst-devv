/*
 *
 * SignUp reducer
 *
 */
import produce from 'immer';
import {
  GET_USER_BY_TOKEN_BEGIN,
  GET_USER_BY_TOKEN_SUCCESS,
  GET_USER_BY_TOKEN_ERROR,
  GET_ONBOARDING_GROUPS_BEGIN,
  GET_ONBOARDING_GROUPS_SUCCESS,
  GET_ONBOARDING_GROUPS_ERROR,
  SUBMIT_PASSWORD_BEGIN,
  SUBMIT_PASSWORD_SUCCESS,
  SUBMIT_PASSWORD_ERROR,
  SIGN_UP_UNMOUNT,
} from './constants';

export const initialState = {
  token: null,
  isLoading: true,
  isGroupsLoading: true,
  isCommitting: false,
  user: null,
  groupList: [],
  groupTotal: null,
  errors: null,
};

function signUpReducer(state = initialState, action) {
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
      case GET_ONBOARDING_GROUPS_BEGIN:
        draft.isGroupsLoading = true;
        break;
      case GET_ONBOARDING_GROUPS_SUCCESS:
        draft.isGroupsLoading = false;
        draft.groupList = action.payload.items;
        draft.groupTotal = action.payload.total;
        break;
      case GET_ONBOARDING_GROUPS_ERROR:
        draft.isGroupsLoading = false;
        break;
      case SUBMIT_PASSWORD_BEGIN:
        draft.isCommitting = true;
        break;
      case SUBMIT_PASSWORD_SUCCESS:
        draft.isCommitting = false;
        break;
      case SUBMIT_PASSWORD_ERROR:
        draft.isCommitting = false;
        draft.errors = action.error.errors;
        break;
      case SIGN_UP_UNMOUNT:
        return initialState;
    }
  });
}

export default signUpReducer;
