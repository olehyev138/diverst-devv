/*
 *
 * Request reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_REQUESTS_BEGIN,
  GET_REQUESTS_SUCCESS,
  GET_REQUESTS_ERROR,
  GET_PROPOSALS_BEGIN,
  GET_PROPOSALS_SUCCESS,
  GET_PROPOSALS_ERROR,
  REQUEST_UNMOUNT,
} from './constants';

export const initialState = {
  requestList: [],
  requestListTotal: null,
  currentRequest: null,
  isFetchingRequests: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function requestReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_REQUESTS_BEGIN:
      case GET_PROPOSALS_BEGIN:
        draft.isFetchingRequests = true;
        break;

      case GET_REQUESTS_ERROR:
      case GET_PROPOSALS_ERROR:
        draft.isFetchingRequests = false;
        break;

      case GET_REQUESTS_SUCCESS:
      case GET_PROPOSALS_SUCCESS:
        draft.requestList = action.payload.items;
        draft.requestListTotal = action.payload.total;
        draft.isFetchingRequests = false;
        break;

      case REQUEST_UNMOUNT:
        return initialState;
    }
  });
}
  export default requestReducer;
