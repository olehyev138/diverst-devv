/*
 *
 * Poll reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_POLL_BEGIN,
  GET_POLL_SUCCESS,
  GET_POLL_ERROR,
  GET_POLLS_BEGIN,
  GET_POLLS_SUCCESS,
  GET_POLLS_ERROR,
  CREATE_POLL_BEGIN,
  CREATE_POLL_SUCCESS,
  CREATE_POLL_ERROR,
  UPDATE_POLL_BEGIN,
  UPDATE_POLL_SUCCESS,
  UPDATE_POLL_ERROR,
  CREATE_POLL_AND_PUBLISH_BEGIN,
  CREATE_POLL_AND_PUBLISH_SUCCESS,
  CREATE_POLL_AND_PUBLISH_ERROR,
  UPDATE_POLL_AND_PUBLISH_BEGIN,
  UPDATE_POLL_AND_PUBLISH_SUCCESS,
  UPDATE_POLL_AND_PUBLISH_ERROR,
  PUBLISH_POLL_BEGIN,
  PUBLISH_POLL_SUCCESS,
  PUBLISH_POLL_ERROR,
  DELETE_POLL_BEGIN,
  DELETE_POLL_SUCCESS,
  DELETE_POLL_ERROR,
  POLLS_UNMOUNT,
} from './constants';

export const initialState = {
  pollList: [],
  pollListTotal: null,
  currentPoll: null,
  isFetchingPolls: true,
  isFetchingPoll: true,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function pollReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_POLL_BEGIN:
        draft.isFetchingPoll = true;
        break;

      case GET_POLL_SUCCESS:
        draft.currentPoll = action.payload.poll;
        draft.isFetchingPoll = false;
        break;

      case GET_POLL_ERROR:
        draft.isFetchingPoll = false;
        break;

      case GET_POLLS_BEGIN:
        draft.isFetchingPolls = true;
        draft.hasChanged = false;
        break;

      case GET_POLLS_SUCCESS:
        draft.pollList = action.payload.items;
        draft.pollListTotal = action.payload.total;
        draft.isFetchingPolls = false;
        break;

      case GET_POLLS_ERROR:
        draft.isFetchingPolls = false;
        break;

      case CREATE_POLL_BEGIN:
      case UPDATE_POLL_BEGIN:
      case CREATE_POLL_AND_PUBLISH_BEGIN:
      case UPDATE_POLL_AND_PUBLISH_BEGIN:
      case PUBLISH_POLL_BEGIN:
      case DELETE_POLL_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_POLL_SUCCESS:
      case UPDATE_POLL_SUCCESS:
      case CREATE_POLL_AND_PUBLISH_SUCCESS:
      case UPDATE_POLL_AND_PUBLISH_SUCCESS:
      case PUBLISH_POLL_SUCCESS:
      case DELETE_POLL_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_POLL_ERROR:
      case UPDATE_POLL_ERROR:
      case CREATE_POLL_AND_PUBLISH_ERROR:
      case UPDATE_POLL_AND_PUBLISH_ERROR:
      case PUBLISH_POLL_ERROR:
      case DELETE_POLL_ERROR:
        draft.isCommitting = false;
        break;

      case POLLS_UNMOUNT:
        return initialState;
    }
  });
}
export default pollReducer;
