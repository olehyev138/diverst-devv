/*
 *
 * Response reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_RESPONSE_BEGIN,
  GET_RESPONSE_SUCCESS,
  GET_RESPONSE_ERROR,
  GET_RESPONSES_BEGIN,
  GET_RESPONSES_SUCCESS,
  GET_RESPONSES_ERROR,
  CREATE_RESPONSE_BEGIN,
  CREATE_RESPONSE_SUCCESS,
  CREATE_RESPONSE_ERROR,
  UPDATE_RESPONSE_BEGIN,
  UPDATE_RESPONSE_SUCCESS,
  UPDATE_RESPONSE_ERROR,
  DELETE_RESPONSE_BEGIN,
  DELETE_RESPONSE_SUCCESS,
  DELETE_RESPONSE_ERROR,
  RESPONSES_UNMOUNT,
} from './constants';

export const initialState = {
  responseList: [],
  responseListTotal: null,
  currentResponse: null,
  isFetchingResponses: false,
  isFetchingResponse: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function responseReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_RESPONSE_BEGIN:
        draft.isFetchingResponse = true;
        break;

      case GET_RESPONSE_SUCCESS:
        draft.currentResponse = action.payload.response;
        draft.isFetchingResponse = false;
        break;

      case GET_RESPONSE_ERROR:
        draft.isFetchingResponse = false;
        break;

      case GET_RESPONSES_BEGIN:
        draft.isFetchingResponses = true;
        draft.hasChanged = false;
        break;

      case GET_RESPONSES_SUCCESS:
        draft.responseList = action.payload.items;
        draft.responseListTotal = action.payload.total;
        draft.isFetchingResponses = false;
        break;

      case GET_RESPONSES_ERROR:
        draft.isFetchingResponses = false;
        break;

      case CREATE_RESPONSE_BEGIN:
      case UPDATE_RESPONSE_BEGIN:
      case DELETE_RESPONSE_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_RESPONSE_SUCCESS:
      case UPDATE_RESPONSE_SUCCESS:
      case DELETE_RESPONSE_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_RESPONSE_ERROR:
      case UPDATE_RESPONSE_ERROR:
      case DELETE_RESPONSE_ERROR:
        draft.isCommitting = false;
        break;

      case RESPONSES_UNMOUNT:
        return initialState;
    }
  });
}
export default responseReducer;
