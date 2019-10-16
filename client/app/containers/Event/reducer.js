/*
 *
 * Event reducer
 *
 */
import produce from 'immer';
import { GET_EVENTS_BEGIN, GET_EVENTS_SUCCESS, EVENTS_UNMOUNT, GET_EVENT_SUCCESS, GET_EVENTS_ERROR, GET_EVENT_ERROR } from './constants';

export const initialState = {
  isLoading: true,
  events: [],
  eventsTotal: null,
  currentEvent: null,
};

/* eslint-disable default-case, no-param-reassign */
function eventsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_EVENTS_BEGIN:
        draft.isLoading = true;
        break;
      case GET_EVENTS_SUCCESS:
        draft.events = action.payload.items;
        draft.eventsTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_EVENTS_ERROR:
        draft.isLoading = false;
        break;
      case GET_EVENT_SUCCESS:
        draft.currentEvent = action.payload.initiative;
        draft.isLoading = false;
        break;
      case GET_EVENT_ERROR:
        draft.isLoading = false;
        break;
      case EVENTS_UNMOUNT:
        return initialState;
    }
  });
}

export default eventsReducer;
