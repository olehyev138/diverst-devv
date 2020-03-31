/*
 *
 * Event actions
 *
 */

import {
  GET_EVENTS_BEGIN,
  GET_EVENTS_SUCCESS,
  GET_EVENTS_ERROR,
  GET_EVENT_BEGIN,
  GET_EVENT_SUCCESS,
  GET_EVENT_ERROR,
  CREATE_EVENT_BEGIN,
  CREATE_EVENT_SUCCESS,
  CREATE_EVENT_ERROR,
  UPDATE_EVENT_BEGIN,
  UPDATE_EVENT_SUCCESS,
  UPDATE_EVENT_ERROR,
  ARCHIVE_EVENT_BEGIN,
  ARCHIVE_EVENT_SUCCESS,
  ARCHIVE_EVENT_ERROR,
  DELETE_EVENT_BEGIN,
  DELETE_EVENT_SUCCESS,
  DELETE_EVENT_ERROR,
  CREATE_EVENT_COMMENT_BEGIN,
  CREATE_EVENT_COMMENT_SUCCESS,
  CREATE_EVENT_COMMENT_ERROR,
  DELETE_EVENT_COMMENT_BEGIN,
  DELETE_EVENT_COMMENT_ERROR,
  DELETE_EVENT_COMMENT_SUCCESS,
  FINALIZE_EXPENSES_BEGIN,
  FINALIZE_EXPENSES_SUCCESS,
  FINALIZE_EXPENSES_ERROR,
  EVENTS_UNMOUNT,
  JOIN_EVENT_ERROR,
  JOIN_EVENT_SUCCESS,
  JOIN_EVENT_BEGIN,
  LEAVE_EVENT_BEGIN,
  LEAVE_EVENT_ERROR,
  LEAVE_EVENT_SUCCESS,
  EXPORT_ATTENDEES_BEGIN,
  EXPORT_ATTENDEES_SUCCESS,
  EXPORT_ATTENDEES_ERROR,
} from './constants';


export function getEventsBegin(payload) {
  return {
    type: GET_EVENTS_BEGIN,
    payload,
  };
}

export function getEventsSuccess(payload) {
  return {
    type: GET_EVENTS_SUCCESS,
    payload,
  };
}

export function getEventsError(error) {
  return {
    type: GET_EVENTS_ERROR,
    error,
  };
}

/* Getting specific event */

export function getEventBegin(payload) {
  return {
    type: GET_EVENT_BEGIN,
    payload,
  };
}

export function getEventSuccess(payload) {
  return {
    type: GET_EVENT_SUCCESS,
    payload,
  };
}

export function getEventError(error) {
  return {
    type: GET_EVENT_ERROR,
    error,
  };
}

/* Event creating */

export function createEventBegin(payload) {
  return {
    type: CREATE_EVENT_BEGIN,
    payload,
  };
}

export function createEventSuccess(payload) {
  return {
    type: CREATE_EVENT_SUCCESS,
    payload,
  };
}

export function createEventError(error) {
  return {
    type: CREATE_EVENT_ERROR,
    error,
  };
}

/* Event updating */

export function updateEventBegin(payload) {
  return {
    type: UPDATE_EVENT_BEGIN,
    payload,
  };
}

export function updateEventSuccess(payload) {
  return {
    type: UPDATE_EVENT_SUCCESS,
    payload,
  };
}

export function updateEventError(error) {
  return {
    type: UPDATE_EVENT_ERROR,
    error,
  };
}

/* Event deleting */

export function deleteEventBegin(payload) {
  return {
    type: DELETE_EVENT_BEGIN,
    payload,
  };
}

export function deleteEventSuccess(payload) {
  return {
    type: DELETE_EVENT_SUCCESS,
    payload,
  };
}

export function deleteEventError(error) {
  return {
    type: DELETE_EVENT_ERROR,
    error,
  };
}

export function finalizeExpensesBegin(payload) {
  return {
    type: FINALIZE_EXPENSES_BEGIN,
    payload,
  };
}

export function finalizeExpensesSuccess(payload) {
  return {
    type: FINALIZE_EXPENSES_SUCCESS,
    payload,
  };
}

export function finalizeExpensesError(error) {
  return {
    type: FINALIZE_EXPENSES_ERROR,
    error,
  };
}

export function eventsUnmount(payload) {
  return {
    type: EVENTS_UNMOUNT,
    payload,
  };
}

export function archiveEventBegin(payload) {
  return {
    type: ARCHIVE_EVENT_BEGIN,
    payload,
  };
}

export function archiveEventSuccess(payload) {
  return {
    type: ARCHIVE_EVENT_SUCCESS,
    payload,
  };
}

export function archiveEventError(error) {
  return {
    type: ARCHIVE_EVENT_ERROR,
    error,
  };
}

/* Event comments */

export function createEventCommentBegin(payload) {
  return {
    type: CREATE_EVENT_COMMENT_BEGIN,
    payload,
  };
}

export function createEventCommentSuccess(payload) {
  return {
    type: CREATE_EVENT_COMMENT_SUCCESS,
    payload,
  };
}


export function createEventCommentError(error) {
  return {
    type: CREATE_EVENT_COMMENT_ERROR,
    error,
  };
}

/* Join Event & Leave Event */
export function joinEventBegin(payload) {
  return {
    type: JOIN_EVENT_BEGIN,
    payload,
  };
}

export function joinEventSuccess(payload) {
  return {
    type: JOIN_EVENT_SUCCESS,
    payload,
  };
}

export function joinEventError(error) {
  return {
    type: JOIN_EVENT_ERROR,
    error,
  };
}

export function leaveEventBegin(payload) {
  return {
    type: LEAVE_EVENT_BEGIN,
    payload,
  };
}

export function leaveEventSuccess(payload) {
  return {
    type: LEAVE_EVENT_SUCCESS,
    payload,
  };
}

export function leaveEventError(error) {
  return {
    type: LEAVE_EVENT_ERROR,
    error,
  };
}

export function deleteEventCommentSuccess(payload) {
  return {
    type: DELETE_EVENT_COMMENT_SUCCESS,
    payload,
  };
}

export function deleteEventCommentError(error) {
  return {
    type: DELETE_EVENT_COMMENT_ERROR,
    error,
  };
}

export function deleteEventCommentBegin(payload) {
  return {
    type: DELETE_EVENT_COMMENT_BEGIN,
    payload,
  };
}

export function exportAttendeesBegin(payload) {
  return {
    type: EXPORT_ATTENDEES_BEGIN,
    payload,
  };
}

export function exportAttendeesSuccess(error) {
  return {
    type: EXPORT_ATTENDEES_SUCCESS,
    error,
  };
}

export function exportAttendeesError(error) {
  return {
    type: EXPORT_ATTENDEES_ERROR,
    error,
  };
}
