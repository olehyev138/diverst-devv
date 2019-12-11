/*
 *
 * Event actions
 *
 */

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

export function eventsUnmount(payload) {
  return {
    type: EVENTS_UNMOUNT,
    payload,
  };
}
