/*
 *
 * PollResponse reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_QUESTIONNAIRE_BY_TOKEN_BEGIN,
  GET_QUESTIONNAIRE_BY_TOKEN_SUCCESS,
  GET_QUESTIONNAIRE_BY_TOKEN_ERROR,
  SUBMIT_RESPONSE_BEGIN,
  SUBMIT_RESPONSE_SUCCESS,
  SUBMIT_RESPONSE_ERROR,
  POLL_RESPONSE_UNMOUNT,
} from './constants';

export const initialState = {
  token: null,
  isLoading: true,
  isCommitting: false,
  response: null,
  errors: null,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function PollResponseReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_QUESTIONNAIRE_BY_TOKEN_BEGIN:
        draft.isLoading = true;
        break;
      case GET_QUESTIONNAIRE_BY_TOKEN_SUCCESS:
        draft.isLoading = false;
        draft.response = action.payload.response;
        draft.token = action.payload.token;
        break;
      case GET_QUESTIONNAIRE_BY_TOKEN_ERROR:
        draft.isLoading = false;
        break;
      case SUBMIT_RESPONSE_BEGIN:
        draft.isCommitting = true;
        break;
      case SUBMIT_RESPONSE_SUCCESS:
        draft.isCommitting = false;
        break;
      case SUBMIT_RESPONSE_ERROR:
        draft.isCommitting = false;
        draft.errors = action.errors.errors;
        break;
      case POLL_RESPONSE_UNMOUNT:
        return initialState;
    }
  });
}
export default PollResponseReducer;
