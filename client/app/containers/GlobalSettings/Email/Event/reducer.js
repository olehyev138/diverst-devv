/*
 *
 * Event reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_EVENT_BEGIN,
  GET_EVENT_SUCCESS,
  GET_EVENT_ERROR,
  GET_EVENTS_BEGIN,
  GET_EVENTS_SUCCESS,
  GET_EVENTS_ERROR,
  CREATE_EVENT_BEGIN,
  CREATE_EVENT_SUCCESS,
  CREATE_EVENT_ERROR,
  UPDATE_EVENT_BEGIN,
  UPDATE_EVENT_SUCCESS,
  UPDATE_EVENT_ERROR,
  DELETE_EVENT_BEGIN,
  DELETE_EVENT_SUCCESS,
  DELETE_EVENT_ERROR,
  EVENTS_UNMOUNT,
} from './constants';

export const initialState = {
  eventList: [],
  eventListTotal: null,
  currentEvent: null,
  isFetchingEvents: false,
  isFetchingEvent: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function eventReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_EVENT_BEGIN:
        draft.isFetchingEvent = true;
        break;

      case GET_EVENT_SUCCESS:
        draft.currentEvent = action.payload.clockwork_database_event;
        draft.isFetchingEvent = false;
        break;

      case GET_EVENT_ERROR:
        draft.isFetchingEvent = false;
        break;

      case GET_EVENTS_BEGIN:
        draft.isFetchingEvents = true;
        draft.hasChanged = false;
        break;

      case GET_EVENTS_SUCCESS:
        draft.eventList = action.payload.items;
        draft.eventListTotal = action.payload.total;
        draft.isFetchingEvents = false;
        break;

      case GET_EVENTS_ERROR:
        draft.isFetchingEvents = false;
        break;

      case CREATE_EVENT_BEGIN:
      case UPDATE_EVENT_BEGIN:
      case DELETE_EVENT_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_EVENT_SUCCESS:
      case UPDATE_EVENT_SUCCESS:
      case DELETE_EVENT_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_EVENT_ERROR:
      case UPDATE_EVENT_ERROR:
      case DELETE_EVENT_ERROR:
        draft.isCommitting = false;
        draft.hasChanged = false;
        break;

      case EVENTS_UNMOUNT:
        return initialState;
    }
  });
}
export default eventReducer;
