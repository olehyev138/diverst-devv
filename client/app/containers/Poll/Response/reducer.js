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
    // eslint-disable-next-line default-case
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

      case RESPONSES_UNMOUNT:
        return initialState;
    }
  });
}
export default responseReducer;
