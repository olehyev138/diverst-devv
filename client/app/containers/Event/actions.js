/*
 *
 * Event actions
 *
 */

import {
  GET_EVENTS_BEGIN, GET_EVENTS_SUCCESS, GET_EVENTS_ERROR,
  EVENTS_UNMOUNT
} from './constants';

export function getEventsBegin(payload) {
  return {
    type: GET_EVENTS_BEGIN,
    payload
  };
}

export function getEventsSuccess(payload) {
  return {
    type: GET_EVENTS_SUCCESS,
    payload
  };
}

export function getEventsError(error) {
  return {
    type: GET_EVENTS_ERROR,
    error
  };
}

export function eventsUnmount() {
  return {
    type: EVENTS_UNMOUNT,
  };
}
