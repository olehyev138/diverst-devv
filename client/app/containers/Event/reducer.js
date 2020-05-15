/*
 *
 * Event reducer
 *
 */
import produce from 'immer';
import {
  GET_EVENTS_BEGIN,
  GET_EVENTS_SUCCESS,
  EVENTS_UNMOUNT,
  GET_EVENT_SUCCESS,
  GET_EVENTS_ERROR,
  GET_EVENT_ERROR,
  CREATE_EVENT_BEGIN,
  UPDATE_EVENT_BEGIN,
  CREATE_EVENT_SUCCESS,
  UPDATE_EVENT_SUCCESS,
  CREATE_EVENT_ERROR,
  UPDATE_EVENT_ERROR,
  GET_EVENT_BEGIN,
  ARCHIVE_EVENT_BEGIN,
  ARCHIVE_EVENT_SUCCESS,
  ARCHIVE_EVENT_ERROR,
  FINALIZE_EXPENSES_BEGIN,
  FINALIZE_EXPENSES_SUCCESS,
  FINALIZE_EXPENSES_ERROR,
  JOIN_EVENT_BEGIN,
  JOIN_EVENT_ERROR,
  JOIN_EVENT_SUCCESS, LEAVE_EVENT_ERROR, LEAVE_EVENT_BEGIN, LEAVE_EVENT_SUCCESS
} from './constants';

import { toNumber } from 'utils/floatRound';

export const initialState = {
  isLoading: true,
  isFormLoading: true,
  isCommitting: false,
  events: [],
  eventsTotal: null,
  currentEvent: null,
  hasChanged: false,
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

      case GET_EVENT_BEGIN:
        draft.isFormLoading = true;
        break;

      case GET_EVENT_SUCCESS:
        draft.currentEvent = action.payload.initiative;
        draft.isFormLoading = false;
        break;

      case GET_EVENT_ERROR:
        draft.isFormLoading = false;
        break;

      case CREATE_EVENT_BEGIN:
      case UPDATE_EVENT_BEGIN:
      case FINALIZE_EXPENSES_BEGIN:
        draft.isCommitting = true;
        break;

      case FINALIZE_EXPENSES_SUCCESS:
        draft.currentEvent = action.payload.initiative;
        draft.isCommitting = false;
        break;

      case CREATE_EVENT_SUCCESS:
      case CREATE_EVENT_ERROR:
      case UPDATE_EVENT_SUCCESS:
      case UPDATE_EVENT_ERROR:
      case FINALIZE_EXPENSES_ERROR:
      case ARCHIVE_EVENT_ERROR:
      case JOIN_EVENT_ERROR:
      case LEAVE_EVENT_ERROR:
        draft.isCommitting = false;
        break;

      case EVENTS_UNMOUNT:
        return initialState;
      case ARCHIVE_EVENT_BEGIN:
      case JOIN_EVENT_BEGIN:
      case LEAVE_EVENT_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;
      case ARCHIVE_EVENT_SUCCESS:
      case JOIN_EVENT_SUCCESS:
        draft.events = state.events.map((event) => {
          if (event.id === toNumber(action.payload.initiative_user.initiative_id))
            return produce(event, (eventDraft) => {
              eventDraft.is_attending = true;
              eventDraft.total_attendees = event.total_attendees + 1;
            });
          return event;
        });
        draft.hasChanged = true;
        draft.isCommitting = false;
        break;
      case LEAVE_EVENT_SUCCESS:
        draft.events = state.events.map((event) => {
          if (event.id === toNumber(action.payload.initiative_user.initiative_id))
            return produce(event, (eventDraft) => {
              eventDraft.is_attending = false;
              eventDraft.total_attendees = event.total_attendees - 1;
            });
          return event;
        });
        draft.hasChanged = true;
        draft.isCommitting = false;
        break;
    }
  });
}

export default eventsReducer;
