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
  UPDATE_EVENT_BEGIN,
  UPDATE_EVENT_SUCCESS,
  UPDATE_EVENT_ERROR,
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

export function eventsUnmount(payload) {
  return {
    type: EVENTS_UNMOUNT,
    payload,
  };
}
