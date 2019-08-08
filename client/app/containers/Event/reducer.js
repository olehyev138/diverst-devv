/*
 *
 * Event reducer
 *
 */
import produce from 'immer';
import { GET_EVENTS_SUCCESS, EVENTS_UNMOUNT, GET_EVENT_SUCCESS } from './constants';

export const initialState = {
  events: [],
  eventsTotal: null,
  currentEvent: null,
};

/* eslint-disable default-case, no-param-reassign */
function eventsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_EVENTS_SUCCESS:
        draft.events = action.payload.items;
        draft.eventsTotal = action.payload.total;
        break;
      case GET_EVENT_SUCCESS:
        draft.currentEvent = action.payload.event;
        break;
      case EVENTS_UNMOUNT:
        return initialState;
    }
  });
}

export default eventsReducer;
