/*
 *
 * Event reducer
 *
 */
import produce from 'immer';
import { GET_EVENTS_SUCCESS, EVENTS_UNMOUNT } from './constants';

export const initialState = {
  events: [],
  eventsTotal: null,
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
      case EVENTS_UNMOUNT:
        return initialState;
    }
  });
}

export default eventsReducer;
